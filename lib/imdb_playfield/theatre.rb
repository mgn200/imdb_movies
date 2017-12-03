module ImdbPlayfield
  # Represent a real life theatre object with schedule, prices and tickets
  class Theatre < ImdbPlayfield::MovieCollection
    include ImdbPlayfield::Cashbox
    include ImdbPlayfield::TheatreBuilder
    include ImdbPlayfield::TheatreSchedule
    include ImdbPlayfield::TimeHelper

    # Gets collection of movies from MovieCollection
    # Creates custom schedule if block is given by user_filters
    # Checks schedule time holes and raises error if found any
    def initialize(&block)
      super
      instance_eval(&block) if block
      check_holes(schedule)
    end

    # Show some movie at given time
    # @param time [String] string in "09:00" format
    # @return [String] with picked movie and when will it start
    def show(time)
      return "Кинотеатр не работает в это время" if session_break?(to_seconds(time))
      params = schedule.find { |period| period.range_time.include?(to_seconds(time)) }.filters
      movie = pick_movie(filter(params))
      "#{movie.title} will be shown at #{time}"
    end

    # Return schedule, created by user or default one
    # @see ImdbPlayfield::TheatreBuilder
    # @see ImdbPlayfield::TheatreSchedule
    def schedule
      @schedule || DEFAULT_SCHEDULE
    end

    # Return halls, created by user or default ones
    # Similar to #schedule
    # @see ImdbPlayfield::Theatre#schedule
    def halls
      @halls || DEFAULT_HALLS
    end

    # Return periods when given title(movie) is being showed
    # @param title [String] movie title
    # @return [Array] with times movie is shown
    def when?(title)
      movie = detect { |x| x.title == title }
      return 'Неверное название фильма' unless movie
      periods = fetch_periods(movie)
      return 'В данный момент этот фильм не идет в кино' if periods.empty?
      to_time_string(periods.map(&:range_time))
    end

    # Return periods whose filters matches with given movie attributes
    # @see ImdbPlayfield::SchedulePeriod#matches?
    # @param movie [<AncientMovie, ModernMovie, NewMovie, ClassicMovie>] movie object
    # @return [Array] of matching periods
    def fetch_periods(movie)
      schedule.select { |period| period.matches?(movie) }
    end

    # Buys ticket to the movie: pay price and choose hall.
    # @param movie_title [String] movie title you want to watch
    # @param hall [Symbol] :red, :blue, :green by default
    # @note
    #   You need to specify hall if one movie can be shown at different schedule periods
    # @return [String] buying confirmation
    def buy_ticket(movie_title, hall = nil)
      range_time = when?(movie_title)
      if range_time.length > 1 && hall.nil?
        halls = range_time.flat_map { |range| schedule.find { |p| p.range_time == range_in_seconds(range) }.hall }
        fail ArgumentError, "Выберите нужный вам зал: #{halls.join(' | ')}"
      end

      price = fetch_price(range_time, hall)
      fail ArgumentError, "Выбран неверный зал. Фильм показывают в зале: " + fetch_halls(range_time).join(" | ") if price.nil?
      store_cash(price)
      "Вы купили билет на #{movie_title}"
    end

    # Fetches price value from schedule based on hall and time range, used in #buy_ticket
    # @see ImdbPlayfield::Theatre#buy_ticket
    # @param range_time [Array] array of time ranges
    # @param hall [Symbol] hall name, as :red, :green, :blue in default schedule
    # @return [Integer] price
    def fetch_price(range_time, hall)
      period = schedule.detect { |period|
        (range_time.include? to_time_string(period.range_time)) && (period.hall.include?(hall))
      }
      period.price unless period.nil?
    end

    # Fetches all halls available in given time range
    # @param range_time [Range] range of time
    # @return [Array] of appropriate halls
    def fetch_halls(range_time)
      schedule.select { |period| range_time.include? to_time_string(period.range_time) }.flat_map(&:hall)
    end

    # Check if given time is an official break time
    # @note
    #   Time outside of whole schedule range, for example tiem between last time range and first time range
    #   is considered session_break
    # @param time [String] "09:00" format
    # @return [Boolean] true if it's sesion break
    def session_break?(time)
      schedule.none? { |p| p.range_time.include? time }
    end


    # Represent schedule in a user-friendly strings
    # @note
    #   When called, it creates an Array of ScheduleLine's objects who hold all the info
    # @see ImdbPlayfield::ScheduleLine
    # @return [String] printed theatre schedule
    def info
      # Один раз создает массив ScheduleLine'ов, в которых содержится
      # отформатированное расписание, в методе print
      organized_schedule ||= organize_schedule(schedule)
      return "Сегодня показываем: \n" + organized_schedule.map { |line| line.print }.join
    end
  end
end
