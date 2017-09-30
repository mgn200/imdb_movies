module MovieProduction
  module TheatreSchedule
    include MovieProduction::TimeHelper
    # Содержит дефолтное расписание для театров
    # Содержит методы для обработки расписания театра
    DEFAULT_SCHEDULE = { ("06:00")..("12:00") => MovieProduction::SchedulePeriod.new({ filters: { period: :ancient },
                                                                                       range_time: ("06:00".."12:00"),
                                                                                       daytime: :morning,
                                                                                       price: 3,
                                                                                       hall: [:red] } ),
                         ("12:00")..("18:00") => MovieProduction::SchedulePeriod.new({ filters: { genre: %w[Comedy Adventure] },
                                                                                       range_time: ("12:00".."18:00"),
                                                                                       daytime: :afternoon,
                                                                                       price: 5,
                                                                                       hall: [:green] } ),
                         ("18:00")..("00:00") => MovieProduction::SchedulePeriod.new({ filters: { genre: %w[Drama Horror] },
                                                                                       range_time: ("18:00".."00:00"),
                                                                                       daytime: :evening,
                                                                                       price: 10,
                                                                                       hall: [:blue] } ),
                         ("00:00")..("06:00") => MovieProduction::SchedulePeriod.new({ range_time: ("00:00".."06:00"),
                                                                                       session_break: true }) }

    DEFAULT_HALLS = { red: { title: 'Красный зал', places: 100 },
                      blue: { title: 'Синий зал', places: 50 },
                      green: { title: 'Зелёный зал (deluxe)', places: 12 } }

    def organize_schedule(schedule)
      schedule.values.reject(&:session_break).flat_map { |params|
        max_duration = period_length(params.range_time)
        pick_movies(params.range_time, params.filters, max_duration)
      }.to_h
    end

    def period_length(range)
      ((range.first - range.last) / 60).abs.to_i
    end

    def pick_movies(range, filters, timeleft)
      # Тянуть залы здесь, или когда принтим?(print_schedule)
      movies = filter(filters)
      picked = []
      halls = schedule.values.detect { |p| p.range_time == range }.hall
      start = range.first
      # Отбросываем фильмы, которые точно не поместятся
      # Выбираем из оставшихся рандомные, снижаем допустимое время
      # Назначаем точное время показа
      while timeleft > 0
        movie = movies.reject { |m| m.duration > timeleft }.sample
        return picked if movie.nil?
        picked << [start, [movie, halls]]
        start += movie.duration * 60
        timeleft -= movie.duration
      end
    end

    # Принтим организованное расписание
    def print_schedule(organized_schedule)
      strings = organized_schedule.map do |time, movie|
        "\t#{to_time_string(time)} #{movie.first.title}(#{movie.first.genre.join(", ")}, #{movie.first.year})." +
        " #{movie.last.join(', ').capitalize} hall(s).\n"
      end
      "Сегодня показываем: \n" + strings.join
    end
  end
end
