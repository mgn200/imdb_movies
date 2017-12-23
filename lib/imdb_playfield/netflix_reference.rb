module ImdbPlayfield
  # A reference class that stores Netflix object.
  # Generate by_#{attribute} DSL methods.
  class NetflixReference
    attr_reader :obj, :key

    def initialize(obj, key)
      @obj = obj
      @key = key
    end

    # Catches by_#{attribute} methods and delegates filtering to public #filter method
    # @see Netflix#filter
    # @example
    #   Netflix.by_country.usa => Array of movies created in USA
    # @param value [String, Numeric, Date] parameter from by_#{value} method call
    def method_missing(value)
      value = value == :usa ? value.to_s.upcase : value.to_s.capitalize
      obj.filter(@key.to_sym => value)
    end
  end
end
