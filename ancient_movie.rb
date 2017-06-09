require 'pry'

class AncientMovie < Movie
  def initialize(list, movie_info)
    super(list, movie_info)
  end

  def to_s
    "#{@title} - старый фильм(#{@year} год)"
  end
end
