module MovieProduction
  module TheatreBuilder
    # for initial halls description
    def hall(name, params)
      halls[name] = params
    end

    def period(range = nil, &block)
      @schedule = {} if schedule == MovieProduction::Theatre::DEFAULT_SCHEDULE
      period = PeriodBuilder.new(range, &block).period
      fail ArgumentError, 'Periods and halls intersection detected. Please check parameters.' if intersection?(period)
      @schedule.merge! period
    end

    def intersection?(built_period)
      # skip to second elemesnt for comparison
      return false if @schedule.empty?

      @schedule.keys.any? do |period|
        if period.overlaps? built_period.keys.first
          return true if (@schedule[period][:hall] & built_period.values.first[:hall]).any?
        end
      end
    end

    def session_break(range)
      period(range) { session_break }
    end

    def check_holes(schedule)
      time_holes = []
      sorted_periods = schedule.keys.sort { |a, b| a.first <=> b.first }
      tested_period = Array.new << sorted_periods.shift
      sorted_periods.each do |range|
        if tested_period.last.cover? range.first
          tested_period.map! { |x| x = Range.new(x.first, range.last) }
        else
          tested_period << range
        end
      end

      if tested_period.length > 1
        tested_period.each_with_index do |range, i|
          break if i == tested_period.length - 1
          time_holes << Range.new(range.max, tested_period[i+1].min)
        end
        fail ArgumentError, "В расписании есть неучтенное время: #{time_holes.join(', ')}"
      end
    end

    class Object::Range
      def overlaps?(other)
        # "11:00" not overlapping another "11:00"
        return false if other.last == first || other.first == last
        cover?(other.first) || other.cover?(first)
      end
    end

    class PeriodBuilder
      attr_accessor :period

      def initialize(range, &block)
        @built_hash = {}
        instance_eval(&block)
        @period = { range => @built_hash }
      end

      def method_missing(key, value)
        if MovieProduction::MovieCollection::KEYS.any? { |k| k.to_sym == key }
        # оборачивать в фильтр параметры, данные вне хэша
        # типа { title: 'abc' } вместо { filters: { title: 'abc' } }
          @built_hash[:filters] = { key => value }
        else
          @built_hash[key] = value
        end
      end

      # for setting periods to hall connection
      def hall(*halls)
        @built_hash[:hall] = halls
      end

      def session_break
        @built_hash[:session_break] = true
      end
    end
  end
end
