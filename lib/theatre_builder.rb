
module MovieProduction
  module TheatreBuilder
    # for initial halls description
    def hall(name, params)
      halls[name] = params
    end

    def period(range, &block)
      @periods = {} if periods == MovieProduction::Theatre::DEFAULT_SCHEDULE
      period = PeriodBuilder.new(range, &block).period
      fail ArgumentError, 'Periods and halls intersection detected. Please check parameters.' if intersection(period)
      @periods.merge! period
    end

    def intersection(built_period)
      # skip to second elemesnt for comparison
      return false if @periods.length < 1

      @periods.keys.any? do |period|
        if period.overlaps? built_period.keys.first
          return true if (@periods[period][:hall] & built_period.values.first[:hall]).any?
        end
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
        # wrap movie attribute in filter hash if it's given alone
        # like: { title: 'abc' } instead of { filters: { title: 'abc' } }
          @built_hash[:filters] =  { key => value }
        else
          @built_hash[key] = value
        end
      end

      # for setting periods to hall connection
      def hall(*halls)
        @built_hash[:hall] = halls
      end
    end
  end
end
