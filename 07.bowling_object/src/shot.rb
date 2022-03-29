# frozen_string_literal: true

class Shot
  def initialize(char)
    @char = char
  end

  def score
    @char.eql?('X') ? 10 : @char.to_i
  end
end
