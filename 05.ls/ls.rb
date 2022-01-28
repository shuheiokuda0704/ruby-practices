#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

class Ls
  MAX_COLUMN_NUM = 3
  COLUMN_MARGIN  = 7

  def initialize(target: '.', params: {})
    return unless File.exist?(target)

    @params = params
    @target = +target
    @is_dir = File.directory?(@target)
    @target.concat('/') if @is_dir && @target[-1] != '/'
    @items = parse_items
    @max_item_name_length = @items.map(&:length).max
  end

  def execute
    unless @items
      puts "ls: #{@target}: No such file or directory"
      return
    end

    render_items
  end

  private

  def parse_items
    items = []

    if @is_dir
      Dir.foreach(@target) do |item|
        items.append(item) if @params.include?(:a) || !item.match?(/^\./)
      end
    else
      items.append(@target)
    end

    @params.include?(:r) ? items.sort.reverse : items.sort
  end

  def render_items
    if @params.include?(:l)
      render_items_for_l
    elsif @is_dir
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
      puts @target
    end
  end

  def render_items_for_l
    item_stats, blocks = format_item_stats
    max_nlink_len = item_stats.map { |stat| stat[:nlink].length }.max
    max_uname_len = item_stats.map { |stat| stat[:uname].length }.max
    max_gname_len = item_stats.map { |stat| stat[:gname].length }.max
    max_size_len  = item_stats.map { |stat| stat[:size].length }.max

    puts "total #{blocks}"
    item_stats.each do |stat|
      puts format("%<md>s  %#{max_nlink_len}<nl>s %#{max_uname_len}<un>s  %#{max_gname_len}<gn>s  %#{max_size_len}<sz>s %<at>s %<in>s",
                  md: stat[:mode], nl: stat[:nlink], un: stat[:uname], gn: stat[:gname], sz: stat[:size], at: stat[:atime], in: stat[:item_name])
    end
  end

  def format_item_stats
    blocks = 0
    item_stats = @items.map do |item|
      item_stat = File.lstat((@is_dir ? @target + item : @target).to_s)
      blocks += item_stat.blocks
      {
        mode: format_mode(item_stat.mode.to_s(8)),
        nlink: item_stat.nlink.to_s,
        uname: Etc.getpwuid(item_stat.uid).name,
        gname: Etc.getgrgid(item_stat.gid).name,
        size: item_stat.size.to_s,
        atime: format_time(item_stat.mtime),
        item_name: item
      }
    end
    [item_stats, blocks]
  end

  def format_mode(mode)
    type_map = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b',
                 '10' => '-', '12' => 'l', '14' => 's' }
    aligned_mode = format('%06<mode>d', mode: mode)
    type_num = aligned_mode.slice(0..1)
    formatted_mode = +type_map[type_num]
    aligned_mode.slice(3..).each_char do |c|
      formatted_mode.concat((c.to_i >> 2).odd? ? 'r' : '-')
      formatted_mode.concat((c.to_i >> 1).odd? ? 'w' : '-')
      formatted_mode.concat((c.to_i >> 0).odd? ? 'x' : '-')
    end
    formatted_mode
  end

  def format_time(time)
    if time > Time.new(Time.now.year - 1, time.mon, time.day, time.hour, time.min, time.sec)
      time.strftime('%_m %_d %H:%M')
    else
      time.strftime('%_m %_d  %Y')
    end
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

  ls = Ls.new(target: ARGV[0] || '.', params: params)
  ls.execute
end
