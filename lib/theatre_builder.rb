module MovieProduction
  module TheatreBuilder
    attr_writer :halls
    attr_writer :periods

    def hall(*params)
      halls[params.first] = params.last
    end

    def period(range, &block)
      @periods = {} if periods == MovieProduction::Theatre::DEFAULT_SCHEDULE
      PeriodScope.new(self, range, &block)
    end

    class PeriodScope
      def initialize(theatre_reference, range, &block)
        @theatre = theatre_reference
        @scope_hash = {}
        instance_eval(&block)
        fail ArgumentError, 'Periods and halls intersection detected. Please check parameters.' if intersection(range, theatre_reference)
        @periods_hash = { range => @scope_hash }
        theatre_reference.periods.merge! @periods_hash
      end

      def method_missing(*params)
        if MovieProduction::MovieCollection::KEYS.any? { |key| key.to_sym == params.first }
          # for standalone params
          # build hash to add to params key
          @scope_hash[:filters] = { params.first => params.last }
        else
          # for non-params attr
          @scope_hash[params.first] = params.last
        end
      end

      def hall(*params)
        @scope_hash[:hall] = params
      end

      def intersection(period, theatre)
        return false if theatre.periods.empty?
        intersect = false
        theatre.periods.each do |range|
          if (period.to_a & range.first.to_a).any? && (@scope_hash[:hall] & range.last[:hall]).any?
            intersect = true
          end
        end
        intersect
      end
    end
  end
end
