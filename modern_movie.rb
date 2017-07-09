require_relative 'movie'

module MovieProduction
  class ModernMovie < MovieProduction::Movie
    PRICE = 3

    def to_s
      actors = @actors.join ","
      "#{@title} - современное кино: играют #{actors}."
    end
  end
end
