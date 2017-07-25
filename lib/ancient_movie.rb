require_relative 'movie'
module MovieProduction
  class AncientMovie < MovieProduction::Movie
    def to_s
      "#{@title} - старый фильм(#{@year} год)"
    end
  end
end
