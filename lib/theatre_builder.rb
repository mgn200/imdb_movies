module MovieProduction
  module TheatreBuilder
    attr_accessor :halls
    attr_accessor :periods

    def hall(*params)
      self.halls[params.first] = params.last
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
        @periods_hash = { range => @scope_hash }
        theatre_reference.periods.merge! @periods_hash
      end

      def method_missing(*params)
        if MovieProduction::MovieCollection::KEYS.any? { |key| key.to_sym == params.first }
          # if two keys are given, first is overwritten
          @scope_hash[:params] = { params.first => params.last }
        else
          @scope_hash[params.first] = params.last
        end
      end

      def hall(*params)
        @scope_hash[:hall] = params
      end
    end
  end
end
