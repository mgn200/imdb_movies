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

    def range_in_seconds(period)
      from = to_seconds(period.begin)
      to = to_seconds(period.end)
      to += 24*60*60 if to < from
      from..to
    end
  end
end
