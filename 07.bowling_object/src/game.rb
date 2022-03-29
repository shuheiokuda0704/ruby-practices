# frozen_string_literal: true

require './src/frame'

class Game
  def initialize(inputs)
    @frames = parse_inputs(inputs)
  end

  def score
    # 倒した本数を合算
    score = @frames.map(&:score).sum

    score + bonus
  end

  private

  def parse_inputs(input)
    frames = []
    first_shot_char = nil

    inputs = input.split(',')
    inputs.each_with_index do |value, index|
      # 9フレーム分埋めたら、残りの入力はすべて10フレームのものとみなす
      if frames.size == 9
        frames.append(Frame.new(inputs[index..]))
        break
      end

      # ストライクなら1投のみなので即フレームを作成する
      frames.append(Frame.new([value])) && next if value.eql?('X')

      # 1投目の入力なら first_shot_char に入れて次の入力に進む、2投目なら first_shot_char と併せてフレームを作成する
      if first_shot_char
        frames.append(Frame.new([first_shot_char, value]))
        first_shot_char = nil
      else
        first_shot_char = value
      end
    end

    frames
  end

  def bonus
    bonus = 0

    # スペア、ストライクのボーナスポイントを算出
    @frames.each_with_index do |frame, index|
      frame_num = index + 1
      next_frame_index = index + 1

      # 10フレーム目は加算なし
      if frame_num != 10
        if frame.spare?
          # スペアは次の1投分を加算
          bonus += @frames[next_frame_index].first_shot.score
        elsif frame.strike?
          # ストライクは次の2投分を加算
          bonus += @frames[next_frame_index].first_shot.score

          bonus += if @frames[next_frame_index].strike?
                     @frames[next_frame_index + 1].first_shot.score
                   else
                     @frames[next_frame_index].second_shot.score
                   end
        end
      end
    end

    bonus
  end
end
