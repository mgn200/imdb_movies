module MovieProduction
  class Theatre < MovieProduction::MovieCollection
    include MovieProduction::Cashbox
    include MovieProduction::TheatreBuilder
    include MovieProduction::TheatreSchedule

    def initialize(&block)
      super
      instance_eval(&block) if block
      check_holes(schedule)
    end

    def show(time)
      return "Кинотеатр не работает в это время" if session_break?(time)
      params = schedule.detect { |key, _hash| key.include?(time) }.last[:filters]
      movie = pick_movie(filter(params))
      "#{movie.title} will be shown at #{time}"
    end

    def schedule
      @schedule || DEFAULT_SCHEDULE
    end

    def halls
      @halls || DEFAULT_HALLS
    end

    def when?(title, hall = nil)
      movie = detect { |x| x.title == title }
      return 'Неверное название фильма' unless movie
      periods = fetch_periods(movie)
      return 'В данный момент этот фильм не идет в кино' if periods.empty?
      return periods.keys unless hall
      period = periods.select { |_time, p| p.hall.include?(hall) }.keys
      return period unless period.empty?
      fail ArgumentError, "Выбран неверный зал. Фильм показывают в зале: " +
                          periods.values.flat_map { |k| k.hall }.join(" | ")
    end

    def fetch_periods(movie)
      schedule.select do |_range, period|
        next if period.session_break
        period.filters.all? { |k, v| movie.matches?(k, v) }
      end
    end

    def buy_ticket(movie_title, hall = nil)
      range_time = when?(movie_title, hall)

      if range_time.length > 1
        halls = range_time.flat_map { |range| schedule[range][:hall] }
        fail ArgumentError, "Выберите нужный вам зал: #{halls.join(' | ')}"
      end

      price = schedule[range_time.first][:price]
      store_cash(price)
      "Вы купили билет на #{movie_title}"
    end

    def session_break?(time)
      period = schedule.detect { |k, _hash| k.include?(time) }.first
      schedule[period][:session_break]
    end

    def info
      string = "Сегодня показываем: "
      @movies ||= organize_schedule(schedule)
      @movies.each do |time, movies|
        start = (Time.parse(time.first)).strftime("%H:%M")
        halls = schedule[time].hall
        if movies.count > 1
          movies.each do |m|
            string += "\n\t#{start} #{m.title}(#{m.genre.join(", ")}, #{m.year}). #{halls.join(', ').capitalize} hall(s)."
            start = (Time.parse(time.first) + (m.duration * 60)).strftime("%H:%M")
          end
        else
          string += "\n\t#{start} #{movies.first.title}(#{movies.first.genre.join(", ")}, " +
                    "#{movies.first.year}). #{halls.join(', ').capitalize} hall(s)."
        end
      end
      string
    end
  end
end
