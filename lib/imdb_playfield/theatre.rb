module ImdbPlayfield
  class Theatre < ImdbPlayfield::MovieCollection
    include ImdbPlayfield::Cashbox
    include ImdbPlayfield::TheatreBuilder
    include ImdbPlayfield::TheatreSchedule
    include ImdbPlayfield::TimeHelper

    def initialize(&block)
      super
      instance_eval(&block) if block
      check_holes(schedule)
    end

    def show(time)
      return "Кинотеатр не работает в это время" if session_break?(to_seconds(time))
      params = schedule.find { |period| period.range_time.include?(to_seconds(time)) }.filters
      movie = pick_movie(filter(params))
      "#{movie.title} will be shown at #{time}"
    end

    def schedule
      @schedule || DEFAULT_SCHEDULE
    end

    def halls
      @halls || DEFAULT_HALLS
    end

    # берет тайтл - возвращает периоды, когда его показывают
    def when?(title)
      movie = detect { |x| x.title == title }
      return 'Неверное название фильма' unless movie
      periods = fetch_periods(movie)
      return 'В данный момент этот фильм не идет в кино' if periods.empty?
      to_time_string(periods.map(&:range_time))
    end

    def fetch_periods(movie)
      schedule.select { |period| period.matches?(movie) }
    end

    # берет тайтл и зал, если всё ок - тащит его цену и снимает деньги за просмотр
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

    def fetch_price(range_time, hall)
      period = schedule.detect { |period|
        (range_time.include? to_time_string(period.range_time)) && (period.hall.include?(hall))
      }
      period.price unless period.nil?
    end

    def fetch_halls(range_time)
      schedule.select { |period| range_time.include? to_time_string(period.range_time) }.flat_map(&:hall)
    end

    def session_break?(time)
      # Возвращает true, если время находится вне всех периодов
      # Время вне установленных периодов автоматически считается перерывом
      schedule.none? { |p| p.range_time.include? time }
    end

    def info
      # Один раз создает массив ScheduleLine'ов, в которых содержится
      # отформатированное расписание, в методе print
      organized_schedule ||= organize_schedule(schedule)
      return "Сегодня показываем: \n" + organized_schedule.map { |line| line.print }.join
    end
  end
end
