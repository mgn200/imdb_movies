require 'pry'
require_relative 'movie'

class NewMovie< Movie
  attr_reader :period, :price

  def initialize(list, movie_info)
    super(list, movie_info)
    @period = 'New'
    @price = 5
  end

  def to_s
    years_passed = Date.today.year - @year
    "#{@title} - новинка, вышло #{years_passed} лет назад!"
  end
end
