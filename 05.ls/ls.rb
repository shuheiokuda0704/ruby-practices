# frozen_string_literal: true

class Ls
  MAX_COLUMN_NUM = 3
  COLUMN_MARGIN  = 7

  def initialize(target_dir: '.')
    @items = parse_directory_items(target_dir)
    @max_item_name_length = @items.map(&:length).max
  end

  def execute
    render_directory_items
  end

  def parse_directory_items(target_dir)
    items = []

    Dir.foreach(target_dir) do |item|
      items.append(item) unless /^\./.match?(item)
    end

    items.sort
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

ls = Ls.new(target_dir: ARGV[0] || '.')
ls.execute
