module ImdbPlayfield
  # Movies that were made from 1968 to 1999.
  # @see MovieCollection#parse_file
  class ClassicMovie < ImdbPlayfield::Movie
    # @return [String] title and movie director data
    def to_s
      movies = list.filter(director: @director).map(&:title).join(',')
      "#{@title} - классический фильм, режиссёр #{@director}(#{movies})"
    end
  end
end
