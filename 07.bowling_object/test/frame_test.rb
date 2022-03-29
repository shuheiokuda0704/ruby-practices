# frozen_string_literal: true

require 'minitest/autorun'
require './src/frame'

class FrameTest < Minitest::Test
  def test_strike
    frame = Frame.new(['X'])

    assert frame.strike?
    assert !frame.spare?
    assert_equal 10, frame.score
    assert_equal 10, frame.first_shot.score
    assert_equal 0, frame.second_shot.score
    assert_equal 0, frame.third_shot.score
  end

  def test_spare
    frame = Frame.new(['1', '9'])

    assert !frame.strike?
    assert frame.spare?
    assert_equal 10, frame.score
    assert_equal 1, frame.first_shot.score
    assert_equal 9, frame.second_shot.score
    assert_equal 0, frame.third_shot.score
  end

  def test_score_9
    frame = Frame.new(['1', '8'])

    assert !frame.strike?
    assert !frame.spare?
    assert_equal 9, frame.score
    assert_equal 1, frame.first_shot.score
    assert_equal 8, frame.second_shot.score
    assert_equal 0, frame.third_shot.score
  end

  def test_score_0
    frame = Frame.new(['0', '0'])

    assert !frame.strike?
    assert !frame.spare?
    assert_equal 0, frame.score
    assert_equal 0, frame.first_shot.score
    assert_equal 0, frame.second_shot.score
    assert_equal 0, frame.third_shot.score
  end

  def test_final_frame_all_strike
    frame = Frame.new(['X', 'X', 'X'])

    assert_equal 30, frame.score
    assert_equal 10, frame.first_shot.score
    assert_equal 10, frame.second_shot.score
    assert_equal 10, frame.third_shot.score
  end

  def test_final_frame_spare_and_strike
    frame = Frame.new(['1', '9', 'X'])

    assert_equal 20, frame.score
    assert_equal 1, frame.first_shot.score
    assert_equal 9, frame.second_shot.score
    assert_equal 10,  frame.third_shot.score
  end

end