class ModernMovie < Movie
  def initialize(list, movie_info)
    super(list, movie_info)
  end

  def to_s
    "#{@title} - современное кино: играют #{@actors.join ","}."
  end
end
