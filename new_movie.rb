require 'pry'
require_relative 'movie'

class NewMovie< Movie
  attr_reader :period
  def initialize(list, movie_info)
    super(list, movie_info)
    @period = 'New'
  end

  def to_s
    "#{@title} - новинка, вышло #{Date.today.year - @year} лет назад!"
  end
end
