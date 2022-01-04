# frozen_string_literal: true

require 'optparse'
require 'date'

class Calendar
  def initialize(year: nil, month: nil)
    @year = year
    @month = month
  end

  def show
    validate_arguments
    show_month_and_year
    show_day_of_week
    show_days
  end

  private

  def validate_arguments
    if @year.nil? || @month.nil?
      current_date = Date.today
      @year  = current_date.year  if @year.nil?
      @month = current_date.month if @month.nil?
    end

    return unless @month < 1 || @month > 12

    puts 'Invalid Option Value. for month, please set 1-12'
    raise ArgumentError
  end

  def show_month_and_year
    printf("%<month>6d月 %<year>4d\n", month: @month, year: @year)
  end

  def show_day_of_week
    puts '日 月 火 水 木 金 土'
  end

  def show_days
    fisrt_day_of_this_month = Date.new(@year, @month, 1)
    last_day_of_this_month  = Date.new(@year, @month, -1)

    print ' ' * 3 * fisrt_day_of_this_month.wday  # Shift for first day

    (fisrt_day_of_this_month.day..last_day_of_this_month.day).each do |day|
      printf('%2d ', day)
      printf("\n") if Date.new(@year, @month, day).saturday?
    end
    printf("\n")
  end
end

year = nil
month = nil
opt = OptionParser.new

begin
  opt.on('-y YEAR')  { |y| year  = y.to_i }
  opt.on('-m MONTH') { |m| month = m.to_i }
  opt.parse!(ARGV)
rescue OptionParser::InvalidOption
  puts 'Invalid Option. Please use -y for year and -m for month'
  raise
end

calendar = Calendar.new(year: year, month: month)
calendar.show
