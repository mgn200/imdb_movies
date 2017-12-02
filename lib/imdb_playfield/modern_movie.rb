module ImdbPlayfield
  # Class for movies that were made in 1945 or older
  # @see MovieCollection#parse_file
  class ModernMovie < ImdbPlayfield::Movie
    # @return [String] with title and actors
    def to_s
      actors = @actors.join ','
      "#{@title} - современное кино: играют #{actors}."
    end
  end
end
