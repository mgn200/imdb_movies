module ImdbPlayfield
  # DSL for easier use of filters
  # @example Filters movie collection stored in Netflix with DSL
  #   "Netflix.by_country.usa" => Array of movies created in USA
  # @see Netflix#initilize
  # @see NetflixReference
  module NetflixDSL
    # @param keys [Array] keys from MovieCollection
    # @see MovieCollection::KEYS
    # @return [NetflixReference] object with auto created by_#{key} methods
    def make_attr_filters(keys)
      keys.each do |key|
        self.class.send(:define_method, "by_#{key}") do
          ImdbPlayfield::NetflixReference.new(self, key)
        end
      end
    end
  end
end
