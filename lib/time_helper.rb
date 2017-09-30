module MovieProduction
  module TimeHelper
    def to_seconds(time)
      t = Time.parse(time)
      # 3600sec = 60min in
      t.min.zero? ? (t.hour * 3600) : (t.hour * 3600 + t.min * 60)
    end

    def to_time_string(seconds)
      if seconds.is_a? Array
        return seconds.map { |range|
          Time.at(range.first).utc.strftime("%H:%M")..Time.at(range.last).utc.strftime("%H:%M")
        }
      end
      Time.at(seconds).utc.strftime("%H:%M")
    end

    def range_in_seconds(string_time)
      # 86400sec = 12 hours
      # Если период начинается с 00 00, то посекунднам начинать с 0
      # если заканчивается 00 00, то считать как 12 часов, с 00:00 до 00:00
      if string_time.first == "00:00"
        t1 = 0
        t2 = to_seconds(string_time.last)
      elsif string_time.last == "00:00"
        t1 = to_seconds(string_time.first)
        t2 = 86400
      else
        t1 = to_seconds(string_time.first)
        t2 = to_seconds(string_time.last)
      end
      Range.new(t1, t2)
    end
  end
end
