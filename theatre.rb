require 'pry'

class Theatre < MovieCollection
  attr_accessor :all

  def initialize(collection)
    @all = collection.all
  end

  def filter(params)
    super
  end

  def show(time)
    params = get_time(time)
    movies = filter(params)
    movie = pick_movie(movies)
    "#{movie.title} will be shown at #{time}"
  end

  def get_time(time)
    #24:00 - 06:00
    case time
    when "06:00".."12:00"
      { period: 'Ancient' }
    when "12:00".."18:00"
      { genre: ['Comedy', 'Adventure'] }
    when "18:00".."24:00"
      { genre: ['Drama', 'Horror'] }
    when "00:00".."06:00"
      abort "Working hours: 06:00 - 00:00"
    end
  end

  def when?(title)
    movie = @all.select { |x| x.title == title }.first
    return 'No such movie' unless movie
    if movie.period == 'Ancient'
      ("06:00".."12:00")
    elsif movie.genre.any? { |x| ['Comedy', 'Adventure'].include? x  }
      ("12:00".."18:00")
    elsif movie.genre.any? { |x| ['Drama', 'Horror'].include? x }
      ("18:00".."24:00")
    end
  end
end
