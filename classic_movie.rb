require 'pry'
require_relative 'movie'

module Movieproduction
  class ClassicMovie < Movieproduction::Movie
    PRICE = 1.5

    def to_s
      # показывать доп. фильмы режиссера
      movies = list.filter(director: @director).map(&:title).join(",")
      "#{@title} - классический фильм, режиссёр #{@director}(#{movies})"
    end
  end
end
