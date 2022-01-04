# fronzen_string_literal: true

class Ls
  MAX_COLUMN_NUM = 3
  COLUMN_MARGIN  = 2

  def execute
    get_directory_items
    put_directory_items
  end

  def get_directory_items
    @items = []
    @max_item_name_length = 0

    Dir.foreach('..') do |item|
      @items.append(item) unless /^\./.match?(item)
      @max_item_name_length = item.length if @max_item_name_length < item.length
    end

    @items.sort!
  end

  def put_directory_items
    row_no = ((@items.length - 1) / MAX_COLUMN_NUM) + 1
    (0..(row_no - 1)).each do |row|
      (0..(MAX_COLUMN_NUM - 1)).each do |column|
        index = MAX_COLUMN_NUM * row + column

        print @items[index]
        break if index == (@items.length - 1)
        next if column == (MAX_COLUMN_NUM - 1)
        print ' ' * (@max_item_name_length - @items[index].length + COLUMN_MARGIN) 
      end

      puts ''
    end
  end
end

ls = Ls.new
ls.execute
