require 'pry'
require_relative 'movie'

class ClassicMovie < Movie
  attr_reader :list, :period

  def initialize(list, movie_info)
    super(list, movie_info)
    @period = 'Classic'
  end

  def to_s
    movies = list.filter(director: @director).map(&:title).join(",")
    "#{@title} - классический фильм, режиссёр #{@director}(#{movies})"
  end
end
