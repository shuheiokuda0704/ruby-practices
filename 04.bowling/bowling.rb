# frozen_string_literal: true

class Bowling
  def initialize(input:)
    @inputs = parse_inputs(input)
  end

  def score
    calculate
  end

  private

  def parse_inputs(input)
    inputs = input.split(',')
    inputs.map do |i|
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

    @inputs.each_with_index do |value, index|
      score += value

      next if frame == 10

      if strike?(first_throw, value)
        frame += 1
        score += @inputs[(index + 1)..(index + 2)].sum
      elsif spare?(first_throw, index)
        first_throw = true
        frame += 1
        score += @inputs[index + 1]
      else
        frame += 1 unless first_throw
        first_throw = !first_throw
      end
    end

    score
  end

  def strike?(first_throw, value)
    first_throw && value == 10
  end

  def spare?(first_throw, index)
    !first_throw && (@inputs[(index - 1)..index]).sum == 10
  end
end

bowling = Bowling.new(input: ARGV[0])
p bowling.score
