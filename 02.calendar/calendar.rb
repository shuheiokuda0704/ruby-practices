# frozen_string_literal: true

require 'optparse'
require 'date'

class Calendar
  attr_accessor :year, :month

  def initialize
    parse_option
  end

  def parse_option
    begin
      opt = OptionParser.new

      opt.on('-y YEAR')  { |y| @year  = y.to_i }
      opt.on('-m MONTH') { |m| @month = m.to_i }
      opt.parse!(ARGV)

      if @year.nil? || @month.nil?
        current_date = Date.today
        @year  = current_date.year  if @year.nil?
        @month = current_date.month if @month.nil?
      end
    rescue OptionParser::InvalidOption
      puts "Invalid Option. Please use -y for year and -m for month"
      raise
    end

    if month < 1 || month > 12
      puts "Invalid Option Value. for month, please set 1-12"
      raise ArgumentError
    end

  end

  def show
    show_month_and_year
    show_day_of_week
    show_days
  end

  private

  def show_month_and_year
    printf("%6d月 %4d\n", @month, @year)
  end

  def show_day_of_week
    puts "日 月 火 水 木 金 土"
  end

  def show_days
    fisrt_day_of_this_month = Date.new(year, month, 1)
    last_day_of_this_month  = Date.new(year, month, -1)

    print " " * 3 * fisrt_day_of_this_month.wday  # Shift for first day

    ( fisrt_day_of_this_month.day..last_day_of_this_month.day ).each do | day |
      printf("%2d ", day)
      printf("\n") if Date.new(year, month, day).saturday?
    end
    printf("\n")
  end
end

calendar = Calendar.new
calendar.show