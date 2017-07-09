require 'pry'
require_relative './movie.rb'
module MovieProduction
  class AncientMovie < MovieProduction::Movie
    PRICE = 1

    def to_s
      "#{@title} - старый фильм(#{@year} год)"
    end
  end
end
