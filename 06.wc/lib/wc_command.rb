# frozen_string_literal: true

def run_wc(paths:, line_only: false)
  items = collect_items(paths)
  items = append_total(items) if items.size > 1
  format_items(items, line_only)
end

def collect_items(paths)
  paths.map do |path|
    next { line_num: 0, word_num: 0, char_num: 0, path: path, dir: true } if File.directory?(path)

    file = File.pipe?(path) ? path : File.open(path, 'r')
    line_num, word_num, char_num = file_stat(file)

    { line_num: line_num, word_num: word_num, char_num: char_num, path: File.pipe?(path) ? '' : path, dir: false }
  end
end

def file_stat(file)
  line_num = 0
  word_num = 0
  char_num = 0

  file.each_line do |line|
    line_num += 1
    word_num += line.split(nil).count
    char_num += line.size
  end

  [line_num, word_num, char_num]
end

def append_total(items)
  line_num = items.sum { |item| item[:line_num] }
  word_num = items.sum { |item| item[:word_num] }
  char_num = items.sum { |item| item[:char_num] }
  items.append({ line_num: line_num, word_num: word_num, char_num: char_num, path: 'total', dir: false })
end

def format_items(items, line_only)
  format_items = items.map do |item|
    if item[:dir]
      STDERR.puts format("wc: %s: read: Is a directory", item[:path])
    elsif line_only
      format(' %7<ln>d %<p>s', ln: item[:line_num], p: item[:path]).rstrip
    else
      format(' %7<ln>d %7<wn>d %7<cn>d %<p>s',
             ln: item[:line_num], wn: item[:word_num], cn: item[:char_num], p: item[:path]).rstrip
    end
  end

  format_items.reject(&:nil?).join("\n")
end
