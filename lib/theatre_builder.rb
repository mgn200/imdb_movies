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

    def holes?(schedule)
      # count total minutes in ranges, transform to hours
      # if 24 hours are not filled, return false
      minutes_passed = 0

      schedule.keys.each do |range|
        start_time = Time.parse(range.first)
        end_time = Time.parse(range.last)

        while start_time.strftime("%H:%M") != end_time.strftime("%H:%M")
          start_time += 60
          minutes_passed += 1
        end
      end

      (minutes_passed / 60) < 24
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
