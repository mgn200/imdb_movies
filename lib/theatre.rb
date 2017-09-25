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
      return periods.map(&:range_time) unless hall
      period = periods.select { |p| p.hall.include?(hall) }.map(&:range_time)
      return period unless period.empty?
      fail ArgumentError, "Выбран неверный зал. Фильм показывают в зале: " +
                          periods.flat_map(&:hall).join(" | ")
    end

    def fetch_periods(movie)
      schedule.values.reject(&:session_break).select { |period| period.matches?(movie) }
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
      @organized_schedule ||= organize_schedule(schedule)
      print_schedule(@organized_schedule)
    end
  end
end
