#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

class Ls
  MAX_COLUMN_NUM = 3
  COLUMN_MARGIN  = 7

  def initialize(target_dir: '.', params: {})
    @params = params
    @target_dir = target_dir
    @target_dir.concat('/') if target_dir[-1] != '/'
    @items = parse_directory_items(target_dir)
    @max_item_name_length = @items.map(&:length).max
  end

  def execute
    render_directory_items
  end

  private

  def parse_directory_items(target_dir)
    items = []

    Dir.foreach(target_dir) do |item|
      items.append(item) if @params.include?(:a) || !item.match?(/^\./)
    end

    @params.include?(:r) ? items.sort.reverse : items.sort
  end

  def render_directory_items
    unless @params.include?(:l)
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
    else
      blocks = 0
      max_nlink_digits = @items.map { |item| File.lstat("#{@target_dir + item}").nlink.to_s.length }.max
      @items.each do |item|
        item_stat = File.lstat("#{@target_dir + item}")
        puts "#{format_mode(item_stat.mode.to_s(8))}  #{format_nlink(item_stat.nlink, max_nlink_digits)}  #{format_uname(item_stat.uid)} #{item_stat.gid} #{item_stat.size} #{item_stat.atime} #{item}"
        blocks += item_stat.blocks
      end
      puts "Blocks: #{blocks}"
    end
  end

  def format_mode(mode)
    type_map = {'01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b',
                '10' => '-', '12' => 'l', '14' => 's'}
    aligned_mode = format("%06<mode>d", mode: mode)
    type_num = aligned_mode.slice(..1)
    formatted_mode = +type_map[type_num]
    aligned_mode.slice(3..).each_char do |c|
      formatted_mode.concat(((c.to_i >> 2) % 2) == 1 ? 'r' : '-')
      formatted_mode.concat(((c.to_i >> 1) % 2) == 1 ? 'w' : '-')
      formatted_mode.concat(((c.to_i >> 0) % 2) == 1 ? 'x' : '-')
    end
    formatted_mode
  end

  def format_nlink(nlink, max_nlink_digits)
    format("%#{max_nlink_digits}d", nlink)
  end

  def format_uname(uid)
    Etc.getpwuid(uid).name
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'optparse'

  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse!(ARGV)

  ls = Ls.new(target_dir: ARGV[0] || '.', params: params)
  ls.execute
end
