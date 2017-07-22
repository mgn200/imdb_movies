require_relative 'movie'
module MovieProduction
  class ClassicMovie < MovieProduction::Movie
    def to_s
      movies = list.filter(director: @director).map(&:title).join(',')
      "#{@title} - классический фильм, режиссёр #{@director}(#{movies})"
    end
  end
end
