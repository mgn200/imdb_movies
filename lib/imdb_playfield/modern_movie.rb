module ImdbPlayfield
  class ModernMovie < ImdbPlayfield::Movie
    def to_s
      actors = @actors.join ','
      "#{@title} - современное кино: играют #{actors}."
    end
  end
end
require_relative 'movie'
