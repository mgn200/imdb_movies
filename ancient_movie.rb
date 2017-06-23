require 'pry'
require_relative 'movie'

class AncientMovie < Movie
  PRICE = 1
  attr_reader :period

  def initialize(list, movie_info)
    super
  end

  def to_s
    print "#{@title} - старый фильм(#{@year} год)"
  end

  def price
    PRICE
  end
end
