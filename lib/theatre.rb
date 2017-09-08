module MovieProduction
  class Theatre < MovieProduction::MovieCollection
    include MovieProduction::Cashbox
    include MovieProduction::TheatreBuilder
    include MovieProduction::TheatreSchedule

    def initialize(&block)
      super
      instance_eval(&block) if block
      fail ArgumentError, 'В расписании есть неучтенное время.' if holes?(schedule)
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
      if hall
        periods = fetch_periods(movie).select { |_key, value| value[:hall].include?(hall) }.keys
        fail ArgumentError, 'Выбран неверный зал' if periods.empty?
      else
        periods = fetch_periods(movie).keys
      end
      return 'В данный момент этот фильм не идет в кино' if periods.empty?
      periods
    end

    def fetch_periods(movie)
      schedule.select do |_range, values|
        next unless values[:session_break].nil?
        values[:filters].all? { |key, value| movie.matches?(key, value) }
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
      # не завершен
      # собирает мувики под расписание и принтит его
      @movies ||= gather_movies(schedule)
      puts 'Сегодня показываем:'
      @movies.each do |x|
        titles = []
        #filter = x.last.last
        movies = x.last.first.each { |y|
          titles << y.title
        }.join(",")
        # так выводить?
        puts "#{x.first} -" + "\n\t#{movies}"
      end
    end
  end
end
