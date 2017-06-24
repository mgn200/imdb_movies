require 'pry'

class Theatre < MovieCollection
  SCHEDULE = { morning: ("06:00".."12:00"),
               noon: ("12:00".."18:00"),
               evening: ("18:00".."24:00")
             }

  def show(time)
    params = get_time(time)
    movies = filter(params)
    movie = pick_movie(movies)
    "#{movie.title} will be shown at #{time}"
  end

  def get_time(time)
    case time
    when SCHEDULE[:morning]
      { period: :ancient }
    when SCHEDULE[:noon]
      { genre: ['Comedy', 'Adventure'] }
    when SCHEDULE[:evening]
      { genre: ['Drama', 'Horror'] }
    else
      abort "Working hours: 06:00 - 00:00"
    end
  end

  def when?(title)
    movie = @all.select { |x| x.title == title }.first
    return 'No such movie' unless movie
    if movie.period == :ancient
      SCHEDULE[:morning]
    elsif movie.has_genre? ['Comedy', 'Adventure']
      SCHEDULE[:noon]
    elsif movie.has_genre? ['Drama', 'Horror']
      SCHEDULE[:evening]
    end
  end
end
