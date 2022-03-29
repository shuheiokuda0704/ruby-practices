# frozen_string_literal: true

require './src/shot'

class Frame
  def initialize(shots)
    @shots = shots.map { |shot| Shot.new(shot) }
  end

  def score
    @shots.map(&:score).sum
  end

  def strike?
    @shots.size == 1 && @shots[0].score == 10
  end

  def spare?
    @shots.size == 2 && (@shots[0].score + @shots[1].score == 10)
  end

  def first_shot
    @shots.size >= 1 ? @shots[0] : Shot.new(nil)
  end

  def second_shot
    @shots.size >= 2 ? @shots[1] : Shot.new(nil)
  end

  def third_shot
    @shots.size >= 3 ? @shots[2] : Shot.new(nil)
  end
end