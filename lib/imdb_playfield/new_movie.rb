module ImdbPlayfield
  # Class for movies that were made in 2000 or after
  # @see MovieCollection#parse_file
  class NewMovie < ImdbPlayfield::Movie
    # @return [String] with title and amount of years passed
    def to_s
      years_passed = Date.today.year - @year
      "#{@title} - новинка, вышло #{years_passed} лет назад!"
    end
  end
end
