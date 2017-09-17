module MovieProduction
  module TheatreBuilder
    # for initial halls description
    def hall(name, params)
      halls[name] = params
    end

    def period(new_range = nil, &block)
      @schedule = {} if schedule == MovieProduction::Theatre::DEFAULT_SCHEDULE
      @new_period = PeriodBuilder.new(new_range, &block).period
      fail ArgumentError, 'Periods and halls intersection detected. Please check parameters.' if intersection?(new_range)
      @schedule[new_range] = @new_period
    end

    def intersection?(new_range)
      # skip to second elemesnt for comparison
      return false if @schedule.empty?

      @schedule.keys.any? do |period|
        if period.overlaps? new_range
          return true if (@schedule[period].hall & @new_period.hall).any?
        end
      end
    end

    def session_break(range)
      period(range) { session_break }
    end

    def check_holes(schedule)
      time_holes = []
      sorted_periods = schedule.keys.sort_by { |x| x.first }
      tested_period = [sorted_periods.shift]

      sorted_periods.each do |range|
        if tested_period.last.cover? range.first
          # или имелось ввиду создавать массив в массиве а не новый рейнж?
          tested_period[-1] = Range.new(tested_period.first.min, range.last)
        else
          tested_period << range
        end
      end

      return if tested_period.length == 1
      tested_period.each_slice(2) do |p1, p2|
        time_holes << Range.new(p1.max, p2.min)
      end
      fail ArgumentError, "В расписании есть неучтенное время: #{time_holes.join(', ')}"
    end

    class Object::Range
      def overlaps?(other)
        # "11:00" not overlapping another "11:00"
        return false if other.last == first || other.first == last
        cover?(other.first) || other.cover?(first)
      end
    end

    class PeriodBuilder
      attr_accessor :period

      def initialize(range, &block)
        @period = MovieProduction::SchedulePeriod.new
        instance_eval(&block)
      end

      def method_missing(key, value)
        if MovieProduction::MovieCollection::KEYS.any? { |k| k.to_sym == key }
        # оборачивать в фильтр параметры, данные вне хэша
        # типа { title: 'abc' } вместо { filters: { title: 'abc' } }
          @period.attributes = { filters: { key => value } }
        else
          @period.attributes = { key => value }
        end
      end

      # for setting periods to hall connection
      def hall(*halls)
        @period.hall = halls
      end

      def session_break
        @period.session_break = true
      end
    end
  end
end
