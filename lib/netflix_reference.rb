module MovieProduction
  class NetflixReference < MovieProduction::Netflix
    attr_reader :obj, :key

    def initialize(obj, key)
      @obj = obj
      @key = key
    end

    def method_missing(value)
      value = value == :usa ? value.to_s.upcase : value.to_s.capitalize
      obj.filter(@key.to_sym => value)
    end
  end
end
