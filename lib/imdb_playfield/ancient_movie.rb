module ImdbPlayfield
  class AncientMovie < ImdbPlayfield::Movie
    def to_s
      "#{@title} - старый фильм(#{@year} год)"
    end
  end
end

#require 'movie'
