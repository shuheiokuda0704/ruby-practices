# frozen_string_literal: true

def run_wc(paths:, line_only: false)
  items = collect_items(paths)
  format_items(items, line_only)
end

def collect_items(paths)
  items = paths.map do |path|
    line_num, word_num, char_num = 0, 0, 0

    file = File.pipe?(path) ? path : File.open(path, 'r') 
    file.each_line do |line|
      line_num += 1
      word_num += line.split(/[[:space:]]/).reject(&:empty?).size
      char_num += line.size
    end

    { line_num: line_num, word_num: word_num, char_num: char_num, path: File.pipe?(path) ? '' : path }
  end

  if items.size > 1
    line_num = items.sum { |item| item[:line_num] }
    word_num = items.sum { |item| item[:word_num] }
    char_num = items.sum { |item| item[:char_num] }
    items.append ({ line_num: line_num, word_num: word_num, char_num: char_num, path: 'total' })
  end

  items
end

def format_items(items, line_only)
  format_items = items.map do |item|
    line_only ?
      format(" %7d %s", item[:line_num], item[:path]).rstrip :
      format(" %7d %7d %7d %s", item[:line_num], item[:word_num], item[:char_num], item[:path]).rstrip
  end

  format_items.join("\n")
end
