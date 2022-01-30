# frozen_string_literal: true

def run_wc(paths:, line_only: false)
  items = collect_items(paths)
  format_items(items, line_only)
end

def collect_items(paths)
  items = paths.map do |path|
    line_num = 0
    word_num = 0
    char_num = 0

    next { line_num: 0, word_num: 0, char_num: 0, path: path, dir: true } if File.directory?(path)

    file = File.pipe?(path) ? path : File.open(path, 'r')
    file.each_line do |line|
      line_num += 1
      word_num += line.split(/[[:space:]]/).reject(&:empty?).size
      char_num += line.size
    end

    { line_num: line_num, word_num: word_num, char_num: char_num, path: File.pipe?(path) ? '' : path, dir: false }
  end

  if items.size > 1
    line_num = items.sum { |item| item[:line_num] }
    word_num = items.sum { |item| item[:word_num] }
    char_num = items.sum { |item| item[:char_num] }
    items.append({ line_num: line_num, word_num: word_num, char_num: char_num, path: 'total', dir: false })
  end

  items
end

def format_items(items, line_only)
  format_items = items.map do |item|
    if item[:dir]
      # format("wc: %s: read: Is a directory", item[:path])   # TODO: STDERR
    elsif line_only
      format(' %7d %s', item[:line_num], item[:path]).rstrip
    else
      format(' %7d %7d %7d %s', item[:line_num], item[:word_num], item[:char_num], item[:path]).rstrip
    end
  end

  format_items.reject(&:nil?).join("\n")
end
