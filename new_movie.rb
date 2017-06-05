require 'pry'
#require './movie.rb'

class NewMovie< Movie
  attr_reader :title, :year

  def initialize(movie_info)
    @title = movie_info[:title]
    @year = movie_info[:year]
  end

  def to_s
    "#{@title} - старый фильм(#{@year})"
  end
end
