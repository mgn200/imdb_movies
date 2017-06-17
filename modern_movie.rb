require_relative 'movie'

class ModernMovie < Movie
  attr_reader :period, :price

  def initialize(list, movie_info)
    super(list, movie_info)
    @period = 'Modern'
    @price = 3
  end

  def to_s
    actors = @actors.join ","
    "#{@title} - современное кино: играют #{actors}."
  end
end
