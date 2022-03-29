# frozen_string_literal: true

require 'minitest/autorun'
require './src/game'

class GameTest < Minitest::Test
  def test_perfect_game
    game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')

    assert_equal 300, game.score
  end

  def test_pattern_score_0
    game = Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')

    assert_equal 0, game.score
  end

  def test_pattern_score_139
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')

    assert_equal 139, game.score
  end

  def test_pattern_score_164
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')

    assert_equal 164, game.score
  end

  def test_pattern_score_107
    game = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')

    assert_equal 107, game.score
  end

  def test_pattern_score_134
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')

    assert_equal 134, game.score
  end

  def test_pattern_score_144
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')

    assert_equal 144, game.score
  end
end
