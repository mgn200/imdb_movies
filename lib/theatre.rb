module MovieProduction
  class Theatre < MovieProduction::MovieCollection
    include MovieProduction::Cashbox
    include MovieProduction::TheatreBuilder
    include MovieProduction::TheatreSchedule
    include MovieProduction::TimeHelper

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

    def when?(title, hall = nil)
      movie = detect { |x| x.title == title }
      return 'Неверное название фильма' unless movie
      periods = fetch_periods(movie)
      return 'В данный момент этот фильм не идет в кино' if periods.empty?
      return to_time_string(periods.map(&:range_time)) unless hall
      period = periods.select { |p| p.hall.include?(hall) }.map(&:range_time)
      return to_time_string(period) unless period.empty?
      fail ArgumentError, "Выбран неверный зал. Фильм показывают в зале: " +
                          periods.flat_map(&:hall).join(" | ")
    end

    def fetch_periods(movie)
      schedule.select { |period| period.matches?(movie) }
    end

    def buy_ticket(movie_title, hall = nil)
      range_time = when?(movie_title, hall)

      if range_time.length > 1
        halls = range_time.flat_map { |range| schedule.find { |p| p.range_time == range_in_seconds(range) }.hall }
        fail ArgumentError, "Выберите нужный вам зал: #{halls.join(' | ')}"
      end
      price = schedule.detect { |period| period.range_time == range_in_seconds(range_time.first) }.price
      store_cash(price)
      "Вы купили билет на #{movie_title}"
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
