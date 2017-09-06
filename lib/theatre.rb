module MovieProduction
  class Theatre < MovieProduction::MovieCollection
    include MovieProduction::Cashbox
    include MovieProduction::TheatreBuilder
    include MovieProduction::TheatreSchedule
    # проверять дырки в расписании после создания + добавить метод season_break
    # для законного указания "дырок"

    def initialize(&block)
      super
      instance_eval(&block) if block
      fail ArgumentError, 'В расписании есть неучтенное время.' if holes?(periods)
    end

    def show(time)
      return "Кинотеатр не работает в это время" if session_break?(time)
      params = periods.detect { |key, hash| key.include?(time) }.last[:filters]
      movie = pick_movie(filter(params))
      "#{movie.title} will be shown at #{time}"
    end

    def periods
      @periods || DEFAULT_SCHEDULE
    end

    def halls
      @halls || DEFAULT_HALLS
    end

    def when?(title, hall = nil)
      movie = detect { |x| x.title == title }

      return 'Неверное название фильма' unless movie
      if hall
        period = periods.select { |_range, values|
          next if !values[:session_break].nil?
          values[:filters].all? { |key, value| movie.matches?(key, value) }
        }.select { |key, value| value[:hall].include? hall }.keys
      fail ArgumentError, 'Выбран неверный зал' if period.empty?
      else

        period = periods.select { |_range, values|
          next if !values[:session_break].nil?
          values[:filters].all? { |key, value| movie.matches?(key, value) }
        }.keys
      end
      return 'В данный момент этот фильм не идет в кино' if period.empty?
      period
    end

    def buy_ticket(movie_title, hall = nil)
      range_time = when?(movie_title, hall)
    fail ArgumentError, 'Выберите нужный вам зал' if range_time.length > 1
      price = periods[range_time.first][:price]
      store_cash(price)
      "Вы купили билет на #{movie_title}"
    end

    def session_break?(time)
      period = periods.detect { |k, hash| k.include?(time) }.first
      periods[period][:session_break]
    end

    def info

      # каждый вызов будет менять период
      # получает данные?
      # выгружает инфу
      #TheatreSchedule.new(theatre) - для каждой инстанции свой
      @movies ||= gather_movies(periods)
      # puts blablabla
      binding.pry
    end
  end
end
