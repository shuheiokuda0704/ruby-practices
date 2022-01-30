# frozen_string_literal: true
require 'minitest/autorun'
require './lib/wc_command'

require 'pathname'

class WcTest < Minitest::Test
  ROOT_PATHNAME = 'test/fixtures/sample-directory'

  def test_wc_command_for_a_file
    target_pathname = "#{ROOT_PATHNAME}/aaa.txt"
    target_pathnames = [ target_pathname ].map { |path| Pathname(path) }

    expected = `wc #{target_pathname}`.chomp
    assert_equal expected, run_wc(pathnames: target_pathnames)
  end

  def test_wc_command_for_plural_files
    target_pathname_1 = "#{ROOT_PATHNAME}/aaa.txt"
    target_pathname_2 = "#{ROOT_PATHNAME}/bbb.txt"
    target_pathnames = [ target_pathname_1, target_pathname_2 ].map { |path| Pathname(path) }

    expected = `wc #{target_pathname_1} #{target_pathname_2}`.chomp
    assert_equal expected, run_wc(pathnames: target_pathnames)
  end

  def test_wc_command_for_a_file_with_l_option
    target_pathname = "#{ROOT_PATHNAME}/aaa.txt"
    target_pathnames = [ target_pathname ].map { |path| Pathname(path) }

    expected = `wc -l #{target_pathname}`.chomp
    assert_equal expected, run_wc(pathnames: target_pathnames, line_only: true)
  end

  def test_wc_command_for_plural_files_with_l_option
    target_pathname_1 = "#{ROOT_PATHNAME}/aaa.txt"
    target_pathname_2 = "#{ROOT_PATHNAME}/bbb.txt"
    target_pathnames = [ target_pathname_1, target_pathname_2 ].map { |path| Pathname(path) }

    expected = `wc -l #{target_pathname_1} #{target_pathname_2}`.chomp
    assert_equal expected, run_wc(pathnames: target_pathnames, line_only: true)
  end

  # def test_wc_command_with_pipe
  #   expected = `ls -l | wc`.chomp
  #   assert_equal expected, run_wc
  # end

  # def test_wc_command_with_pipe_with_l_option
  #   expected = `ls -l | wc -l`.chomp
  #   assert_equal expected, run_wc
  # end
end
