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
    "#{@title} - новинка, вышло #{Date.today.year - @year} лет назад!"
  end
end
