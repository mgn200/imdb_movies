module MovieProduction
  class Theatre < MovieProduction::MovieCollection
    include MovieProduction::Cashbox

    SCHEDULE = { ("06:00".."12:00") => { period: :ancient },
                 ("12:00".."18:00") => { genre: %w[Comedy Adventure] },
                 ("18:00".."24:00") => { genre: %w[Drama Horror] },
                 ("00:00".."06:00") => 'Working hours: 06:00 - 00:00' }.freeze

    DAYTIME = { SCHEDULE.keys[0] => :morning,
                SCHEDULE.keys[1] => :afternoon,
                SCHEDULE.keys[2] => :evening }.freeze

    PRICES = { DAYTIME.values[0] => 3,
               DAYTIME.values[1] => 5,
               DAYTIME.values[2] => 10 }.freeze

    def initialize(&block)
      block_given? ? MovieProduction::TheatreBuilder.new(&block) : super
    end

    def show(time)
      params = get_time(time)
      return params if params.is_a? String
      movies = filter(params)
      movie = pick_movie(movies)
      "#{movie.title} will be shown at #{time}"
    end

    def get_time(time)
      SCHEDULE.detect { |key, _hash| key.include?(time) }.last
    end

    def when?(title)
      movie = detect { |x| x.title == title }
      return 'No such movie' unless movie
      SCHEDULE.detect { |_range, filter| filter.select.any? { |key, value| movie.matches? key, value } }.first
    rescue
      'That movie is not at the box office atm'
    end

    def buy_ticket(movie_title)
      range_time = when?(movie_title)
      daytime = Theatre::DAYTIME.detect { |range, _time| range == range_time }.last
      price = Theatre::PRICES.detect { |time, _price| daytime == time }.last
      store_cash(price)
      "Вы купили билет на #{movie_title}"
    end
  end
end
