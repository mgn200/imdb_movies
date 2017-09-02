module MovieProduction
  class Theatre < MovieProduction::MovieCollection
    include MovieProduction::Cashbox
    include MovieProduction::TheatreBuilder
    # проверять дырки в расписании после создания + добавить метод season_break
    # для законного указания "дырок"
    DEFAULT_SCHEDULE = { ("06:00".."12:00") => { filters: { period: :ancient },
                                                 daytime: :morning,
                                                 price: 3,
                                                 hall: [:red] },
                         ("12:00".."18:00") => { filters: { genre: %W[Comedy Adventure] },
                                                 daytime: :afternoon,
                                                 price: 5,
                                                 hall: [:green] },
                         ("18:00".."24:00") => { filters: { genre: %w[Drama Horror] },
                                                 daytime: :evening,
                                                 price: 10,
                                                 hall: [:blue] }
                                               }

    DEFAULT_HALLS = { :red => { title: 'Красный зал', places: 100 },
                      :blue => { title: 'Синий зал', places: 50 },
                      :green => { title: 'Зелёный зал (deluxe)', places: 12 } }

    def initialize(&block)
      super
      instance_eval(&block) if block
      fail ArgumentError, 'В расписании есть неучтенное время.' if holes?(@periods)
    end

    def show(time)
      return 'Кинотеатр не работает в это время' if session_break?(time)
      params = get_params(time)
      movies = filter(params)
      movie = pick_movie(movies)
      "#{movie.title} will be shown at #{time}"
    end

    def periods
      @periods || DEFAULT_SCHEDULE
    end

    def halls
      @halls || DEFAULT_HALLS
    end

    def get_params(time)
      periods.detect { |key, _hash| key.include?(time) }.last[:filters]
    end

    def when?(title, hall = nil)
      movie = detect { |x| x.title == title }
      binding.pry
      return 'Неверное название фильма' unless movie
      if hall
        period = periods.select { |_range, values| values[:filters].all? { |key, value| movie.matches?(key, value) } }
                               .select { |key, value| value[:hall].include? hall }
                               .keys
      fail ArgumentError, 'Выбран неверный зал' if period.empty?
      else
        period = periods.select { |_range, values| values[:filters].all? { |key, value| movie.matches?(key, value) } }.keys
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

    # for default schedule, with no #holes? check
    def session_break?(time)
      !periods.keys.any? { |x| x.include? time }
    end

    def info
      # агрегатор, который собирает инфу из..класса?
      # TheatreSchedule ? TheatreSchedule.new(theatre) - для каждой инстанции свой 
      # after DSL "inject" movies to be showing
    end
  end
end
