module MovieProduction
  module TheatreBuilder
    attr_accessor :halls

    def hall(*params)
      # из параметров создавай хэш вида
      # red => { title: 'Красный зал', places: 100 } }
      # добавляй другие туда же
      @halls ||= {}
      @halls[params.first] = params.last
    end

    def period(range, &block)
      PeriodScope.new(self, range, &block)
      #binding.pry
    end

    class PeriodScope
      def initialize(theatre_reference, range, &block)
        @builded_hash = {}
        instance_eval(&block)
        periods_hash = { range => @builded_hash }
        # theatre @all = nil
        binding.pry
        theatre_reference.instance_variable_set(:@periods, periods_hash )
      end

      def hall(*params)
        @builded_hash[:hall] = params.first
      end

      def description(*params)
        @builded_hash[:description] = params.first
      end

      def filters(*params)
        @builded_hash[:filters] = params.first
      end

      def price(*params)
        @builded_hash[:price] = params.first
      end
    end
  end
end
