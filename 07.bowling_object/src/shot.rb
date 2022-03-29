# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(char)
    @char = char
  end

  def score
    return @char.eql?('X') ? 10 : @char.to_i
  end
end