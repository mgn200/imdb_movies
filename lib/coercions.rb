module MovieProduction
  class Coercions
    class Integer < Virtus::Attribute
      def coerce(value)
        value.to_i
      end
    end

    class Splitter < Virtus::Attribute
      def coerce(value)
        value.split(',') if value
      end
    end

    class DateParse < Virtus::Attribute
      def coerce(value)
        value && value.length > 4 ? Date.strptime(value, '%Y-%m') : value
      end
    end

    class RangeInSeconds < Virtus::Attribute
      include MovieProduction::TimeHelper

      def coerce(value)
        range_in_seconds(value)
      end
    end
  end
end
