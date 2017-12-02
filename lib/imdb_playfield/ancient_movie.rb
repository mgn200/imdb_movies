module ImdbPlayfield
  # Class for movies that were made in 1945 or older
  # @see MovieCollection#parse_file
  class AncientMovie < ImdbPlayfield::Movie
    # @return [String] with title and year information.
    def to_s
      "#{@title} - старый фильм(#{@year} год)"
    end
  end
end
