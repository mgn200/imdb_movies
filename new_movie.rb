require 'pry'
require_relative 'movie'

class NewMovie< Movie
  PRICE = 5

  def to_s
    years_passed = Date.today.year - @year
    "#{@title} - новинка, вышло #{years_passed} лет назад!"
  end
end
