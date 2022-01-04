# frozen_string_literal: true

class Ls
  MAX_COLUMN_NUM = 3
  COLUMN_MARGIN  = 2

  def initialize(target_dir: '.')
    @target_dir = target_dir
  end

  def execute
    parse_directory_items
    render_directory_items
  end

  def parse_directory_items
    @items = []
    @max_item_name_length = 0

    Dir.foreach(@target_dir) do |item|
      @items.append(item) unless /^\./.match?(item)
      @max_item_name_length = item.length if @max_item_name_length < item.length
    end

    @items.sort!
  end

  def render_directory_items
    row_length = ((@items.length - 1) / MAX_COLUMN_NUM) + 1

    (0..(row_length - 1)).each do |row|
      (0..(MAX_COLUMN_NUM - 1)).each do |column|
        index = row + column * row_length

        print @items[index]
        break if ((row + 1) * (column + 1)) > (@items.length - 1)
        next if column == (MAX_COLUMN_NUM - 1)

        print ' ' * (@max_item_name_length - @items[index].length + COLUMN_MARGIN)
      end

      puts ''
    end
  end
end

ls = Ls.new(target_dir: ARGV[0] || '.')
ls.execute
