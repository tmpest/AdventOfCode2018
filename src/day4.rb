#!/usr/bin/env ruby -w

INPUT_REGEX = /\[(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d\d):(?<minute>\d\d)\] (?<body>.+)\n/
ASLEEP_REGEX = /falls asleep/
AWAKE_REGEX = /wakes up/
SHIFT_REGEX = /Guard #(?<id>\d+) begins shift/



def sorted_insert(data, e)
  (0..(data.length-1)).each do |i|
    if compare_blob(e, data[i]) <= 0 then
      data.insert(i, e)
      return data
    end
  end
  data.push(e)
  return data
end

def compare_blob(l, r)
  l[:time] <=> r[:time]
end

# guard id -> { :total, :max, :max_min}
def find_sleepy_guard(path_to_input, out)
  timeline = []
  File.open(path_to_input, "r") do |input|
    input.each_line do |line|
      parsed_line = INPUT_REGEX.match(line)
      blob =
      {
        :time => Time.new(parsed_line[:year], parsed_line[:month], parsed_line[:day], parsed_line[:hour], parsed_line[:minute]),
        :body => parsed_line[:body]
      }

      timeline = sorted_insert(timeline, blob)
    end
  end

  File.open(out, "w") do |output|
    (0..(timeline.length-1)).each do |i|
      output.write "#{i}: #{timeline[i][:time]} - #{timeline[i][:body]}\n"
    end
  end


  guard_map = {}
  current = nil
  start = nil
  timeline.each do |blob|
    shift = SHIFT_REGEX.match(blob[:body])
    if !shift.nil? then
      guard_id = shift[:id].to_i
      current = guard_map[guard_id]
      current = {:id => guard_id, :total => 0, :max => 0, :mins => []} if current.nil?
    elsif !AWAKE_REGEX.match(blob[:body]).nil? then
     time_asleep = (blob[:time] - start) / 60 # https://ruby-doc.org/core-2.2.0/Time.html#method-i-2D - Time minus Time returns a float for difference in seconds, Time minus numeric returns new Time object
     current[:total] = current[:total] + time_asleep
     current[:max] = time_asleep if time_asleep > current[:max]
     (start.min..(blob[:time].min -  1)).each { |i|  current[:mins].push i}
     guard_map[current[:id]] = current
    elsif !ASLEEP_REGEX.match(blob[:body]).nil? then
      start = blob[:time]
    end
  end

  # max = 0
  # result = 0
  # guard_map.values.each do |entry|
  #   if entry[:total] > max then
  #     max = entry[:total]
  #     result = entry
  #   end
  # end



  # frequency = {}
  # result[:mins].each do |min|
  #   frequency[min].nil? ? frequency[min] = 1 : frequency[min] += 1
  # end

  # mode_min = result[:mins].sort_by {|min| frequency[min]}.last
  # return mode_min * result[:id]

  guard_map.values.each do |entry|
    frequency = {}
    entry[:mins].each do |min|
      frequency[min].nil? ? frequency[min] = 1 : frequency[min] += 1
    end
    entry[:mode_min] = entry[:mins].sort_by {|min| frequency[min]}.last
    entry[:max_freq] = frequency[entry[:mode_min]]
  end

  result = guard_map.values.sort_by {|v| v[:max_freq]}.last

  return result[:id] * result[:mode_min]
end

puts find_sleepy_guard(ARGV[0], ARGV[1])
