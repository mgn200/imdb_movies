require 'pry'
require_relative 'movie'

class ClassicMovie < Movie
  attr_reader :period, :price

  def initialize(list, movie_info)
    super(list, movie_info)
    @period = 'Classic'
    @price = 1.5
  end

  def to_s
    # показывать доп. фильмы режиссера
    movies = list.filter(director: @director).map(&:title).join(",")
    "#{@title} - классический фильм, режиссёр #{@director}(#{movies})"
  end
end
