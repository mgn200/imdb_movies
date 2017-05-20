require './movie_collection.rb'
class Movie
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
    @genre.include?(genre) ? true : raise {"Error"}
  end

end
