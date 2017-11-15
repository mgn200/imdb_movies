module ImdbPlayfield
  class ClassicMovie < ImdbPlayfield::Movie
    def to_s
      movies = list.filter(director: @director).map(&:title).join(',')
      "#{@title} - классический фильм, режиссёр #{@director}(#{movies})"
    end
  end
end

#require 'movie'
