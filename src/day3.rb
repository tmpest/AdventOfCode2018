#!/usr/bin/env ruby -w

#https://adventofcode.com/2018/day/3

# Given 1000 x 1000 grid
# Given series of inputs formatted as: #<id> @ <Top left Corner X>,<Top left Corner y>: <Width>x<Height>
# Return number of squares that are overlapped twice or more
INPUT_REGEX = /#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)/
SIZE = 1000

def print_blanket(blanket, file_out=nil)
  rows = Array.new(SIZE, "") # This won't work, will create 1 string "" and use SIZE references to it
  blanket.each do |blanket_column|
    blanket_column.each_with_index do |square, y|
      rows[y] += square.to_s + " "
    end
  end
  if file_out.nil? then
    rows.each { |row| puts row }
  else
    File.open(file_out, "a") do |file|
      rows.each { |row| file.write(row + "\n") }
    end
  end
end

def detect_super_overlaps(path_to_input, path_to_output)
  blanket = Array.new(SIZE) {Array.new(SIZE, 0)} # Must be done this way, numbers are literal and therefore can be used in the dual param Array initialize method
  #Putting the inner array inside the first initialize will just reference the same inner array SIZE times instead of creating SIZE new Arrays
  #https://stackoverflow.com/questions/27064163/filling-populating-a-multidimensional-array-with-elements-of-another-array-an

  File.open(path_to_input, "r") do |input|
    input.each_line do |line|
      parsed_line = INPUT_REGEX.match(line)
      (parsed_line[:x].to_i..(parsed_line[:x].to_i + parsed_line[:w].to_i - 1)).each do |x|
        (parsed_line[:y].to_i..(parsed_line[:y].to_i + parsed_line[:h].to_i - 1)).each do |y|
          blanket[x - 1][y - 1] += 1
        end
      end
    end
  end

  count = 0;
  blanket.each do |blanket_column|
    blanket_column.each do |square|
      count += 1 if square >= 2
    end
  end

  return count
end

def find_non_overlapping(path_to_input)
  blanket = Array.new(SIZE) {Array.new(SIZE, 0)} # Must be done this way, numbers are literal and therefore can be used in the dual param Array initialize method
  #Putting the inner array inside the first initialize will just reference the same inner array SIZE times instead of creating SIZE new Arrays
  #https://stackoverflow.com/questions/27064163/filling-populating-a-multidimensional-array-with-elements-of-another-array-an

  entries = []
  File.open(path_to_input, "r") do |input|
    input.each_line do |line|
      parsed_line = INPUT_REGEX.match(line)
      entries.push parsed_line
      (parsed_line[:x].to_i..(parsed_line[:x].to_i + parsed_line[:w].to_i - 1)).each do |x|
        (parsed_line[:y].to_i..(parsed_line[:y].to_i + parsed_line[:h].to_i - 1)).each do |y|
          blanket[x - 1][y - 1] += 1
        end
      end
    end
  end

  valid_results = []
  entries.each do |entry|
    valid = true
    (entry[:x].to_i..(entry[:x].to_i + entry[:w].to_i - 1)).each do |x|
      (entry[:y].to_i..(entry[:y].to_i + entry[:h].to_i - 1)).each do |y|
        valid = false if blanket[x - 1][y - 1] > 1
      end
    end
    valid_results.push entry[:id] if valid
  end

 puts valid_results
end
 v 
#puts detect_super_overlaps ARGV[0], ARGV[1]
puts find_non_overlapping ARGV[0]
