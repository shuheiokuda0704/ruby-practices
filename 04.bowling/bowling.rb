# frozen_string_literal: true

class Bowling
  def initialize(input:)
    @inputs = input
  end

  def score
    parse_inputs
    @score = calculate
    @score
  end

  private

  def parse_inputs
    @inputs_array = @inputs.split(',')
    @inputs_array.map! do |i|
      if i.eql?('X')
        10
      else
        i.to_i
      end
    end
  end

  def calculate
    score = 0
    frame = 1
    first_throw = true
    @inputs_array.each_with_index do |value, index|
      score += value

      if frame != 10
        if first_throw && value == 10
          # strike
          frame += 1

          # Next 2 throws are added as additional points
          score = score + @inputs_array[index + 1] + @inputs_array[index + 2]
        elsif !first_throw && (value + @inputs_array[index - 1]) == 10
          # spare
          first_throw = !first_throw
          frame += 1

          # Next throw is added as additional point
          score += @inputs_array[index + 1]
        else
          frame += 1 unless first_throw
          first_throw = !first_throw
        end
      end
    end

    score
  end
end

bowling = Bowling.new(input: ARGV[0])
p bowling.score
