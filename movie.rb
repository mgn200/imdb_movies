require './movie_collection.rb'
require 'date'

class Movie
  attr_reader :list, :link, :title, :year, :country, :date, :genre,
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
    @date = parse_date(@date)
    AncientMovie.new(movie_info)
  end

  def to_s
    "#{@title}, #{@detailed_year}, #{@director}, #{@rating}"
  end

  def month
    Date::MONTHNAMES[@date.mon] unless @date.nil?
  end

  def has_genre?(genre)
    fail ArgumentError, 'Invalid genre name' unless @list.has_genre? genre
    @genre.include? genre
  end

  def matches?(key, value)
    func = send(key)
    if func.is_a? Array
      func.any? { |x| value === x }
    else
      value === func
    end
  end

  private

  def create_movie_type
    if @year < 1950
      AncientMovie.new
    end
  end

  def parse_date(date)
    @date = Date.strptime(date, '%Y-%m') if date.length > 4
  end
end

require './ancient_movie.rb'
