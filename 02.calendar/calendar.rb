# frozen_string_literal: true

require 'optparse'
require 'date'

class Calendar
  def initialize(year: nil, month: nil)
    @year = year || Date.today.year
    @month = month || Date.today.month
  end

  def show
    show_month_and_year
    show_day_of_week
    show_days
  end

  private

  def show_month_and_year
    printf("%<month>6d月 %<year>4d\n", month: @month, year: @year)
  end

  def show_day_of_week
    puts '日 月 火 水 木 金 土'
  end

  def show_days
    today = Date.today

    fisrt_date = Date.new(@year, @month, 1)
    last_date  = Date.new(@year, @month, -1)

    print ' ' * 3 * fisrt_date.wday  # Shift for first day

    (fisrt_date..last_date).each do |date|
      if date == today
        highlight_printf('%2d ', date.day)
      else
        printf('%2d ', date.day)
      end
      printf("\n") if date.saturday?
    end
    printf("\n")
  end

  def highlight_printf(format, *arg)
    print "\e[31m"
    printf(format, *arg)
    print "\e[0m"
  end
end

year = nil
month = nil
opt = OptionParser.new

begin
  opt.on('-y YEAR', Integer)  { |y| year  = y }
  opt.on('-m MONTH', Integer) { |m| month = m }
  opt.parse!(ARGV)
rescue OptionParser::InvalidOption
  puts 'Invalid Option. Please use -y for year and -m for month'
  raise
end

calendar = Calendar.new(year: year, month: month)
calendar.show
