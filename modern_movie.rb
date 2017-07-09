require_relative 'movie'

module Movieproduction
  class ModernMovie < Movieproduction::Movie
    PRICE = 3

    def to_s
      actors = @actors.join ","
      "#{@title} - современное кино: играют #{actors}."
    end
  end
end
