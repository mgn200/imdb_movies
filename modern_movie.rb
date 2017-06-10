require_relative 'movie'

class ModernMovie < Movie
  attr_reader :period
  def initialize(list, movie_info)
    super(list, movie_info)
    @period = 'Modern'
  end

  def to_s
    "#{@title} - современное кино: играют #{@actors.join ","}."
  end
end
