require './movie_collection.rb'
class Movie < MovieCollection
  attr_reader :link, :title, :year, :country, :detailed_year, :genre,
              :duration, :rating, :director, :actors

  def initialize(list, movie_info)
    @list = list
    movie_info.each do |k, v|
      if k == 'year' || k == 'duration'
        self.instance_variable_set "@#{k}", v.to_i
      else
        self.instance_variable_set "@#{k}", v
      end
    end
  end

  def actors
    Array(@actors)
  end

  def to_s
    "#{@title}, #{@detailed_year}, #{@director}, #{@rating}"
  end

  #def inspect
  #  Hash[instance_variables.map { |name| [name, instance_variable_get(name)]}]
  #end

  def has_genre?(genre)
    return @genre.include? genre if @list.has_genre? genre
    fail ArgumentError, 'Invalid genre name' unless @genre.include? genre
  end
end
