require 'pry'

class Theatre < MovieCollection

  def show(time)
    params = get_time(time)
    movies = filter(params)
    movie = pick_movie(movies)
    "#{movie.title} will be shown at #{time}"
  end

  def get_time(time)
    case time
    when "06:00".."12:00"
      { period: :ancient }
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
    if movie.period == :ancient
      ("06:00".."12:00")
    elsif movie.has_genre? ['Comedy', 'Adventure']
      ("12:00".."18:00")
    elsif movie.has_genre? ['Drama', 'Horror']
      ("18:00".."24:00")
    end
  end
end
