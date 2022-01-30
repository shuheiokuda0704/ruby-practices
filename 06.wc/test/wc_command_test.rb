# frozen_string_literal: true

require 'minitest/autorun'
require './lib/wc_command'

class WcTest < Minitest::Test
  ROOT_PATH = 'test/fixtures/sample-directory'

  def test_wc_command_for_a_file
    target_path = "#{ROOT_PATH}/aaa.txt"

    expected = `wc #{target_path}`.chomp
    assert_equal expected, run_wc(paths: [target_path])
  end

  def test_wc_command_for_plural_files
    target_path_a = "#{ROOT_PATH}/aaa.txt"
    target_path_b = "#{ROOT_PATH}/bbb.txt"

    expected = `wc #{target_path_a} #{target_path_b}`.chomp
    assert_equal expected, run_wc(paths: [target_path_a, target_path_b])
  end

  def test_wc_command_for_a_file_with_l_option
    target_path = "#{ROOT_PATH}/aaa.txt"

    expected = `wc -l #{target_path}`.chomp
    assert_equal expected, run_wc(paths: [target_path], line_only: true)
  end

  def test_wc_command_for_plural_files_with_l_option
    target_path_a = "#{ROOT_PATH}/aaa.txt"
    target_path_b = "#{ROOT_PATH}/bbb.txt"

    expected = `wc -l #{target_path_a} #{target_path_b}`.chomp
    assert_equal expected, run_wc(paths: [target_path_a, target_path_b], line_only: true)
  end

  def test_wc_for_a_file
    expected = `wc #{ROOT_PATH}/aaa.txt`
    actual = `bin/wc.rb #{ROOT_PATH}/aaa.txt`
    assert_equal expected, actual
  end

  def test_wc_for_wildcard
    expected = `wc #{ROOT_PATH}/*`
    actual = `bin/wc.rb #{ROOT_PATH}/*`
    assert_equal expected, actual
  end

  def test_wc_with_pipe
    expected = `ls -l #{ROOT_PATH} | wc`
    actual = `ruby ../05.ls/ls.rb -l #{ROOT_PATH} | bin/wc.rb `
    assert_equal expected, actual
  end

  def test_wc_with_pipe_with_l_option
    expected = `ls -l #{ROOT_PATH} | wc -l`
    actual = `ruby ../05.ls/ls.rb -l #{ROOT_PATH} | bin/wc.rb -l`
    assert_equal expected, actual
  end
end
