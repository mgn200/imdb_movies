require 'pry'
require_relative 'movie'

class ClassicMovie < Movie
  PRICE = 1.5
  attr_reader :period

  def initialize(list, movie_info)
    super(list, movie_info)
  end

  def to_s
    # показывать доп. фильмы режиссера
    movies = list.filter(director: @director).map(&:title).join(",")
    print "#{@title} - классический фильм, режиссёр #{@director}(#{movies})"
  end

  def price
    PRICE
  end
end
