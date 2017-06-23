require 'pry'
require_relative 'movie'

class NewMovie< Movie
  PRICE = 5
  attr_reader :period, :price

  def initialize(list, movie_info)
    super(list, movie_info)
  end

  def price
    PRICE
  end

  def to_s
    years_passed = Date.today.year - @year
    print "#{@title} - новинка, вышло #{years_passed} лет назад!"
  end
end
