require 'pry'
require_relative 'movie'

class AncientMovie < Movie
  attr_reader :period, :price
  def initialize(list, movie_info)
    super(list, movie_info)
    @period = 'Ancient'
    @price = 1
  end

  def to_s
    "#{@title} - старый фильм(#{@year} год)"
  end
end
