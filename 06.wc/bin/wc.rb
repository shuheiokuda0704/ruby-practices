#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'

require_relative '../lib/wc_command'

opt = OptionParser.new

params = { line_only: false }
opt.on('-l') { |v| params[:line_only] = v }
opt.parse!(ARGV)

paths = ARGV.size.zero? && File.pipe?(STDIN) ? [STDIN] : ARGV

puts run_wc(paths: paths, **params)
