require_relative 'movie'

class ModernMovie < Movie
  PRICE = 3
  attr_reader :period

  def initialize(list, movie_info)
    super(list, movie_info)
  end

  def to_s
    actors = @actors.join ","
    print "#{@title} - современное кино: играют #{actors}."
  end

  def price
    PRICE
  end
end
