require 'pry'

class NewMovie< Movie
  def initialize(list, movie_info)
    super(list, movie_info)
  end

  def to_s
    "#{@title} - новинка, вышло #{Date.today.year - @year} лет назад!"
  end
end
