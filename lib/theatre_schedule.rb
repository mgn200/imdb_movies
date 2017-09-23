module MovieProduction
  module TheatreSchedule
    # Содержит дефолтное расписание для театров
    # Содержит методы для обработки расписания театра
    DEFAULT_SCHEDULE = { ("06:00".."12:00") => MovieProduction::SchedulePeriod.new({ filters: { period: :ancient },
                                                                                     range_time: "06:00".."12:00",
                                                                                     daytime: :morning,
                                                                                     price: 3,
                                                                                     hall: [:red] } ),
                         ("12:00".."18:00") => MovieProduction::SchedulePeriod.new({ filters: { genre: %w[Comedy Adventure] },
                                                                                     range_time: "12:00".."18:00",
                                                                                     daytime: :afternoon,
                                                                                     price: 5,
                                                                                     hall: [:green] } ),
                         ("18:00".."24:00") => MovieProduction::SchedulePeriod.new({ filters: { genre: %w[Drama Horror] },
                                                                                     range_time: "18:00".."24:00",
                                                                                     daytime: :evening,
                                                                                     price: 10,
                                                                                     hall: [:blue] } ),
                         ("00:00".."06:00") => MovieProduction::SchedulePeriod.new({ session_break: true }) }

    DEFAULT_HALLS = { red: { title: 'Красный зал', places: 100 },
                      blue: { title: 'Синий зал', places: 50 },
                      green: { title: 'Зелёный зал (deluxe)', places: 12 } }

    def organize_schedule(schedule)
      schedule.values.reject(&:session_break).map { |x|
        max_duration = period_length(x.range_time)
        [x.range_time, pick_movies(x.filters, max_duration)]
      }.to_h
    end

    def period_length(range)
      start_time = Time.parse(range.first)
      end_time = Time.parse(range.last)
      ((start_time - end_time) / 60).abs.to_i
    end

    def pick_movies(filters, timeleft)
      movies = filter(filters)
      picked = []
      # Отбросываем фильмы, которые точно не поместятся
      # Выбираем из оставшихся рандомные, снижаем допустимое время
      while timeleft > 0
        movie = movies.reject { |m| m.duration > timeleft }.sample
        return picked if movie.nil?
        timeleft -= movie.duration
        picked << movie
      end
    end


    # Создает массив из строк с временем показа, описанием фильма и залами
    # Если фильмов в периоде несколько, создаем время для каждого(идут подряд один за другим)
    def create_time_strings(range, movies)
      halls = schedule[range].hall
      start = Time.parse(range.first).strftime("%H:%M")
      str = ""
      movies.each do |m|
        str += "\t#{start} #{m.title}(#{m.genre.join(", ")}, #{m.year}). #{halls.join(', ').capitalize} hall(s).\n"
        start = (Time.parse(start) + m.duration * 60).strftime("%H:%M")
      end
      str
    end
  end
end
