module MovieProduction
  module NetflixDSL
    def make_attr_filters(keys)
      keys.each do |key|
        self.class.send(:define_method, "by_#{key}") do
          NetflixReference.new(self, key)
        end
      end
    end
  end
end
