module MovieProduction
  class Theatre < MovieProduction::MovieCollection
    include MovieProduction::Cashbox
    include MovieProduction::TheatreBuilder
    DEFAULT_SCHEDULE = { ("06:00".."12:00") => { params: { period: :ancient },
                                                 daytime: :morning,
                                                 price: 3 },
                         ("12:00".."18:00") => { params: { genre: %w[Comedy Adventure] },
                                                 daytime: :afternoon,
                                                 price: 5 },
                         ("18:00".."24:00") => { params: { genre: %w[Drama Horror] },
                                                 daytime: :evening,
                                                 price: 10 }
                                               }

    DEFAULT_HALLS = { :red => { title: 'Красный зал', places: 100 },
                      :blue => { title: 'Синий зал', places: 50 },
                      :green => { title: 'Зелёный зал (deluxe)', places: 12 } }

    #DAYTIME = { SCHEDULE.keys[0] => :morning,
                #SCHEDULE.keys[1] => :afternoon,
                #SCHEDULE.keys[2] => :evening }.freeze

    #PRICES = { DAYTIME.values[0] => 3,
    #           DAYTIME.values[1] => 5,
    #           DAYTIME.values[2] => 10 }.freeze

    def initialize(&block)
      super
      instance_eval(&block) if block
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
      periods.detect { |key, _hash| key.include?(time) }.last[:params]
    end

    def when?(title, hall)
      # refactor?
      movie = detect { |x| x.title == title }
      return 'No such movie' unless movie
      # matches? doesnt work with exclude_country
      if hall
        period = periods.select { |_range, values| values[:params].select.any? { |key, value| movie.matches?(key, value) } }
                        .select { |key, value| value[:hall].include? hall }
                        .keys
      fail ArgumentError, 'Выбран неверный зал' if period.empty?
      else
        period = periods.select { |_range, values| values[:params].select.any? { |key, value| movie.matches?(key, value) } }.keys
      end
      period
    end

    def buy_ticket(movie_title, hall = nil)
      range_time = when?(movie_title, hall)
    fail ArgumentError, 'Выберите нужный вам зал' if range_time.length > 1
      return 'That movie is not at the box office atm' if range_time.nil?
      price = periods[range_time.first][:price]
      store_cash(price)
      "Вы купили билет на #{movie_title}"
    end

    def session_break?(time)
      !periods.keys.any? { |x| x.include? time }
    end
  end
end
