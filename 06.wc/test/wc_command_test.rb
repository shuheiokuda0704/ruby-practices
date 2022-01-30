# frozen_string_literal: true
require 'minitest/autorun'
require './lib/wc_command'

require 'pathname'

class WcTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixtures/sample-directory')

  def test_wc_command_for_a_file
    expected = `wc #{TARGET_PATHNAME}/aaa.txt`.chomp
    assert_equal expected, run_wc
  end

  def test_wc_command_for_wildcard
    expected = `wc #{TARGET_PATHNAME}/*`.chomp
    assert_equal expected, run_wc
  end

  def test_wc_command_for_a_file_with_l_option
    expected = `wc -l #{TARGET_PATHNAME}/aaa.txt`.chomp
    assert_equal expected, run_wc
  end

  def test_wc_command_for_wildcard_with_l_option
    expected = `wc -l #{TARGET_PATHNAME}/*`.chomp
    assert_equal expected, run_wc
  end

  def test_wc_command_with_pipe
    expected = `ls -l | wc`.chomp
    assert_equal expected, run_wc
  end

  def test_wc_command_with_pipe_with_l_option
    expected = `ls -l | wc -l`.chomp
    assert_equal expected, run_wc
  end
end
