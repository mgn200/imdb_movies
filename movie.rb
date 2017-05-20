require './movie_collection.rb'
class Movie < MovieCollection

  attr_reader :link, :title, :year, :country, :detailed_year, :genre,
              :duration, :rating, :director, :main_actors

  def initialize(movie_info)
    movie_info.each do |k, v|
      self.instance_variable_set "@#{k}", v
    end
  end

  def main_actors
    Array(@main_actors)
  end

  def stats

  end

  def to_s
    "#{@title}, #{@detailed_year}, #{@director}, #{@rating}"
  end
end
