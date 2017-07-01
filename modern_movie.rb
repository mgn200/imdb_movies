require_relative 'movie'

class ModernMovie < Movie
  PRICE = 3

  def to_s
    actors = @actors.join ","
    "#{@title} - современное кино: играют #{actors}."
  end
end
