module MovieProduction
  module TheatreSchedule
    # Содержит дефолтное расписание для театров
    # Содержит методы для обработки расписания театра
    DEFAULT_SCHEDULE = { ("06:00".."12:00") => { filters: { period: :ancient },
                                                 daytime: :morning,
                                                 price: 3,
                                                 hall: [:red] },
                         ("12:00".."18:00") => { filters: { genre: %w[Comedy Adventure] },
                                                 daytime: :afternoon,
                                                 price: 5,
                                                 hall: [:green] },
                         ("18:00".."24:00") => { filters: { genre: %w[Drama Horror] },
                                                 daytime: :evening,
                                                 price: 10,
                                                 hall: [:blue] },
                         ("00:00".."06:00") => { :session_break => true }
                       }

    DEFAULT_HALLS = { :red => { title: 'Красный зал', places: 100 },
                      :blue => { title: 'Синий зал', places: 50 },
                      :green => { title: 'Зелёный зал (deluxe)', places: 12 } }

    def gather_movies(schedule)
      ranges_and_movies = {}

      schedule.each do |k, v|
        next if v[:session_break]
        max_duration = period_length(k)
        movies = filter(v[:filters], max_duration)
        ranges_and_movies[k] = [movies, v[:filters]]
      end
      ranges_and_movies
    end

    def period_length(range)
      start_time = Time.parse(range.first)
      end_time = Time.parse(range.last)
      ((start_time - end_time) / 60).abs.to_i
    end

    def filter(range_filters, max_duration)
      movies = []
      initial_movies = super(range_filters).select { |x| x.duration <= max_duration }
      initial_movies.shuffle.each do |movie|
        next if movie.duration > max_duration
        movies << movie
        max_duration -= movie.duration
      end
      movies
    end
  end
end
