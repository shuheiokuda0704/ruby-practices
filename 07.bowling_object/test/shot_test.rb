# frozen_string_literal: true

require 'minitest/autorun'
require './src/shot'

class ShotTest < Minitest::Test
  def test_return10
    shot = Shot.new('X')
    assert_equal 10, shot.score
  end

  def test_return9
    shot = Shot.new('9')
    assert_equal 9, shot.score
  end

  def test_return0
    shot = Shot.new('0')
    assert_equal 0, shot.score
  end

  def test_return_0_for_nil
    shot = Shot.new(nil)
    assert_equal 0, shot.score
  end
end
