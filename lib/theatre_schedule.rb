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

    def pick_movies(range_filters, max_duration)
      movies = filter(range_filters).shuffle
      picked = []
      while max_duration > movie_duration ||= 0
        picked << movies.select do |m|
          # movie_duration нужен для сравнения в while, иначе селектит на 1 мувик больше
          movie_duration = m.duration
          m.duration <= max_duration
          max_duration -= movie_duration
        end
      end
      picked.flatten
    end

    def parse_schedule(range, movies, strings)
      halls = schedule[range].hall
      start = Time.parse(range.first).strftime("%H:%M") # + (m.duration * 60)).strftime("%H:%M")
      movies.each do |x|
        strings << "\t#{start} #{x.title}(#{x.genre.join(", ")}, #{x.year}). #{halls.join(', ').capitalize} hall(s).\n"
        start = (Time.parse(start) + x.duration * 60).strftime("%H:%M") #(x.duration * 60)).strftime("%H:%M")
      end
    end
  end
end
