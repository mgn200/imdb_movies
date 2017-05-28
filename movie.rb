require './movie_collection.rb'
require 'date'

class Movie < MovieCollection
  attr_reader :list, :link, :title, :year, :country, :detailed_year, :genre,
              :duration, :rating, :director, :actors

  def initialize(list, movie_info)
    movie_info.each do |k, v|
      if k == 'year' || k == 'duration'
        self.instance_variable_set "@#{k}", v.to_i
      else
        self.instance_variable_set "@#{k}", v
      end
    end
    @list = list
    @actors = @actors.split ","
    @genre = @genre.split ","
  end

  def to_s
    "#{@title}, #{@detailed_year}, #{@director}, #{@rating}"
  end

  def month
    if @detailed_year.length > 4
      m = Date.strptime(@detailed_year, '%Y-%m').mon
      Date::MONTHNAMES[m]
    else
      nil
    end
  end

  def has_genre?(genre)
    fail ArgumentError, 'Invalid genre name' unless @list.has_genre? genre
    return @genre.include? genre
  end

  def matches?(key, value)
    if send(key).is_a? Array
      send(key).any? { |x| value === x }
    else
      value === send(key)
    end
  end
end
