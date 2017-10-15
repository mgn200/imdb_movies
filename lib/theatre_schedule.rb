module MovieProduction
  module TheatreSchedule
    include MovieProduction::TimeHelper
    # Содержит дефолтное расписание для театров
    # Содержит методы для обработки расписания театра
    DEFAULT_SCHEDULE = [MovieProduction::SchedulePeriod.new(
                                           "06:00".."12:00",
                                           filters: { period: :ancient },
                                           price: 3,
                                           hall: %i[red]
                                          ),
                        MovieProduction::SchedulePeriod.new(
                                           "12:00".."18:00",
                                           filters: { genre: %w[Comedy Adventure] },
                                           range_time: ("12:00".."18:00"),
                                           price: 5,
                                           hall: %i[green]
                                          ),
                        MovieProduction::SchedulePeriod.new(
                                           "18:00".."00:00",
                                           filters: { genre: %w[Drama Horror] },
                                           range_time: ("18:00".."00:00"),
                                           price: 10,
                                           hall: %i[blue]
                                         )]

    DEFAULT_HALLS = { red: { title: 'Красный зал', places: 100 },
                      blue: { title: 'Синий зал', places: 50 },
                      green: { title: 'Зелёный зал (deluxe)', places: 12 } }

    def organize_schedule(schedule)
      schedule.flat_map { |period|
        pick_movies(period.range_time, period.filters, period.period_length)
      }
    end

    def pick_movies(range, filters, timeleft)
      movies = filter(filters)
      picked = schedule_line
      halls = schedule.detect { |p| p.range_time == range }.hall
      start = range.first
      # Отбросываем фильмы, которые точно не поместятся
      # Выбираем из оставшихся рандомные, снижаем допустимое время
      # Создаем объект ScheduleLine, который занимается печатью строки расписания
      while timeleft > 0
        movie = movies.reject { |m| m.duration > timeleft }.sample
        return picked if movie.nil?
        picked << schedule_line(start: start, movie: movie, halls: halls)
        start += movie.duration * 60
        timeleft -= movie.duration
      end
    end

    def schedule_line(start:, movie:, halls:)
      MovieProduction::ScheduleLine.new(start: start, movie: movie, halls: halls)
    end
  end
end
