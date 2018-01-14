module ImdbPlayfield
  # Helper module, time format change methods
  module TimeHelper
    # @param time [String] "09:00"
    # @return [Integer] seconds from 00:00 till given time
    def to_seconds(time)
      t = Time.parse(time)
      t.min.zero? ? (t.hour * 3600) : (t.hour * 3600 + t.min * 60)
    end

    # Return formatted time string, i.e "09:00"
    # @param seconds [Integer] number of seconds
    # @return [String, Array] of seconds passed from 00:00 in HH:MM format
    def to_time_string(seconds)
      # Seconds ranges can be given like that:
      #[123..123, 123..123]
      #123..123
      #123
      if seconds.is_a? Array
        return seconds.map { |range|
          Time.at(range.first).utc.strftime("%H:%M")..Time.at(range.last).utc.strftime("%H:%M")
        }
      elsif seconds.is_a? Range
        Time.at(seconds.first).utc.strftime("%H:%M")..Time.at(seconds.last).utc.strftime("%H:%M")
      else
        Time.at(seconds).utc.strftime("%H:%M")
      end
    end

    # Formats "09:00".."11:00" to 32400..39600 seconds format
    # @param period [Range]
    # @return [Range] formatted range in seconds
    def range_in_seconds(period)
      from = to_seconds(period.begin)
      to = to_seconds(period.end)
      to += 24*60*60 if to < from
      from..to
    end
  end
end
