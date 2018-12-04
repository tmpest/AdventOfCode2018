#!/usr/bin/env ruby -w

#https://adventofcode.com/2018/day/2
# Checksum of input where the checksum is D x T
# D = instances where exactly 2 characters are repeated in a line
# T = instances where exactly 3 characters are repeated in a line

def checksum(path)
  doubles = 0;
  triples = 0;
  File.open(path, "r") do |input|
    input.each_line do |line|
      character_counter_hash = {}
      line.chars.each do |c|
        count = character_counter_hash[c].nil? ? 1 : character_counter_hash[c] + 1
        character_counter_hash[c] = count
      end

      contains_double = false
      contains_triple = false
      character_counter_hash.each_value do |count|
        contains_double = true if count == 2
        contains_triple = true if count == 3
      end
      doubles += 1 if contains_double
      triples += 1 if contains_triple
    end
  end

  puts doubles * triples
end

# Part 2
# https://adventofcode.com/2018/day/2#part2
# find 2 strings that differ by 1 character, print out the character in common

def word_difference(word1, word2)
  count = 0

  (0..word1.length).each do |i|
    count += 1 unless word1.chars[i] == word2.chars[i]
  end
  return count
end

def find_box(path)

  lines = []
  File.open(path, "r") do |input|
    input.each_line do |line|
      lines << line
    end
  end

  line = lines.pop
  while line != nil
    lines.each do |compare_line|
      if word_difference(line, compare_line) == 1 then
        result = ""
        compare_line_chars = compare_line.chars
        line.chars.each do |c|
          result += c if compare_line_chars.shift == c
        end
        puts result
        return
      end
    end
    line = lines.pop
  end
  puts "Found Nothing"
end
#checksum(ARGV[0])
find_box (ARGV[0])
