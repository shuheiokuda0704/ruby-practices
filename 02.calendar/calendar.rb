# frozen_string_literal: true

require 'optparse'
require 'date'

class Calendar
  def initialize(year: nil, month: nil)
    current_date = Date.today
    @year = year || current_date.year
    @month = month || current_date.month
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
    today_date = Date.today

    fisrt_day_of_this_month = Date.new(@year, @month, 1)
    last_day_of_this_month  = Date.new(@year, @month, -1)

    print ' ' * 3 * fisrt_day_of_this_month.wday  # Shift for first day

    (fisrt_day_of_this_month.day..last_day_of_this_month.day).each do |day|
      current_date = Date.new(@year, @month, day)

      if current_date == today_date
        print "\e[31m"
        printf('%2d ', day)
        print "\e[0m"
      else
        printf('%2d ', day)
      end
      printf("\n") if current_date.saturday?
    end
    printf("\n")
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
