module ImdbPlayfield
  # Movies that were made in 1945 or later.
  # @see ImdbPlayfield::MovieCollection#parse_file
  class AncientMovie < ImdbPlayfield::Movie
    # @return [String] title and year information.
    def to_s
      "#{@title} - старый фильм(#{@year} год)"
    end
  end
end
