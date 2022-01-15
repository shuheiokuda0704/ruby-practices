#!/usr/bin/env ruby
# frozen_string_literal: true

class Ls
  MAX_COLUMN_NUM = 3
  COLUMN_MARGIN  = 7

  def initialize(target_dir: '.', params: {})
    @params = params
    @items = parse_directory_items(target_dir)
    @max_item_name_length = @items.map(&:length).max
  end

  def execute
    render_directory_items
  end

  def parse_directory_items(target_dir)
    items = []

    Dir.foreach(target_dir) do |item|
      items.append(item) if @params.include?(:a) || !item.match?(/^\./)
    end

    @params.include?(:r) ? items.sort.reverse : items.sort
  end

  def render_directory_items
    row_length = ((@items.length - 1) / MAX_COLUMN_NUM) + 1

    row_length.times do |row|
      MAX_COLUMN_NUM.times do |column|
        index = row + column * row_length
        print @items[index]

        break if ((row + 1) * (column + 1)) > @items.length
        next if column == (MAX_COLUMN_NUM - 1)

        print ' ' * (@max_item_name_length - @items[index].length + COLUMN_MARGIN)
      end

      puts ''
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'optparse'

  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.parse!(ARGV)

  ls = Ls.new(target_dir: ARGV[0] || '.', params: params)
  ls.execute
end
