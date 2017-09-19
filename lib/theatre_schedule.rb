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
      organized = {}
      binding.pry
      schedule.values.reject(&:session_break).map do |x|
        binding.pry
      end
      schedule.each do |k, v|
        arr = []
        next if v.session_break
        max_duration = period_length(k)
        organized[k] = pick_movies(v.filters, max_duration, arr).flatten
      end
      organized
    end

    def period_length(range)
      start_time = Time.parse(range.first)
      end_time = Time.parse(range.last)
      ((start_time - end_time) / 60).abs.to_i
    end

    def pick_movies(range_filters, max_duration, array)
      movie = filter(range_filters).select { |x| x.duration <= max_duration }
                                   .sample
      return array if movie.nil?
      array << movie
      max_duration -= movie.duration
      pick_movies(range_filters, max_duration, array)
    end
  end
end
