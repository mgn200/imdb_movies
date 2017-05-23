require './movie_collection.rb'
class Movie < MovieCollection
  attr_reader :link, :title, :year, :country, :detailed_year, :genre,
              :duration, :rating, :director, :actors

  def initialize(movie_info)
    movie_info.each do |k, v|
      self.instance_variable_set "@#{k}", v
    end
  end

  def actors
    Array(@actors)
  end

  def to_s
    "#{@title}, #{@detailed_year}, #{@director}, #{@rating}"
  end

  def has_genre?(genre)
    return @genre.include? genre if super
    fail ArgumentError, 'Invalid genre name' unless @genre.include? genre
  end
end
