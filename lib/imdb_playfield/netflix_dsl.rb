module ImdbPlayfield
  # DSL for easier use of filters.
  # @example
  #   Filters movie collection stored in Netflix with DSL
  #   Netflix.by_country.usa => Array of movies created in USA
  # @see Netflix#initilize
  # @see NetflixReference
  module NetflixDSL
    # @param keys [Array] keys from {MovieCollection::KEYS}
    # @return [NetflixReference] stores auto created by_(movie_attribute) methods, so that you can filter collection like MovieCollection.by_country "USA"
    def make_attr_filters(keys)
      keys.each do |key|
        self.class.send(:define_method, "by_#{key}") do
          ImdbPlayfield::NetflixReference.new(self, key)
        end
      end
    end
  end
end
