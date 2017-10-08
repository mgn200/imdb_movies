module MovieProduction
  class SchedulePeriod
    include Enumerable
    include Virtus.model

    attribute :range_time, Coercions::RangeInSeconds
    attribute :filters
    attribute :price
    attribute :hall
    attribute :description

    # Переопределяем initialize, чтобы виртус увидел неименованный time
    # и coercions нормально работал
    def initialize(time, **options)
      super(options.merge(range_time: time))
    end

    def matches?(movie)
      @filters.all? { |k, v| movie.matches?(k, v) }
    end

    def pick_movies(range, filters, timeleft)
      # Тянуть залы здесь, или когда принтим?(print_schedule)
      movies = filter(params.filters)
      timeleft = period_length
      #picked = []
      #halls = schedule.values.detect { |p| p.range_time == range }.hall
      start = range.first
      # Отбросываем фильмы, которые точно не поместятся
      # Выбираем из оставшихся рандомные, снижаем допустимое время
      # Назначаем точное время показа
      while timeleft > 0
        movie = movies.reject { |m| m.duration > timeleft }.sample
        return picked if movie.nil?
        ScheduleLine.new(start, movie)
        #picked << [start, [movie, halls]]
        start += movie.duration * 60
        timeleft -= movie.duration
      end
    end

    def period_length
      ((range_time.first - range_time.last) / 60).abs.to_i
    end
  end
end
