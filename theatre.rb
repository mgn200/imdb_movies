require 'pry'

class Theatre < MovieCollection
  SCHEDULE = { ("06:00".."12:00") => { period: :ancient },
               ("12:00".."18:00") => { genre: ['Comedy', 'Adventure'] },
               ("18:00".."24:00") => { genre: ['Drama', 'Horror'] },
               ("00:00".."06:00") => 'Working hours: 06:00 - 00:00'
             }

  def show(time)
    params = get_time(time)
    return params if params.is_a? String
    movies = filter(params)
    movie = pick_movie(movies)
    "#{movie.title} will be shown at #{time}"
  end

  def get_time(time)
    SCHEDULE.detect { |key, hash| key === time }[1]
  end

  def when?(title)
    movie = @all.detect { |x| x.title == title }
    return 'No such movie' unless movie
    SCHEDULE.detect { |range, filter|
      filter.select.any? { |key, value| movie.matches? key, value }
    }.first
  end
end
