module ImdbPlayfield
  module TheatreBuilder
    include ImdbPlayfield::TimeHelper
    # for initial halls description
    def hall(name, params)
      halls[name] = params
    end

    def period(new_range = nil, &block)
      #range_in_seconds = to_seconds(new_range.first)..to_seconds(new_range.last) if new_range
      @schedule = [] if schedule == ImdbPlayfield::Theatre::DEFAULT_SCHEDULE
      @new_period = PeriodBuilder.new(new_range, &block).period
      fail ArgumentError, 'Periods and halls intersection detected. Please check parameters.' if intersection?(new_range)
      schedule << @new_period
    end

    def intersection?(new_range)
      # skip to second elemesnt for comparison
      return false if schedule.empty?
      schedule.any? do |period|
        if period.range_time.overlaps? range_in_seconds(new_range)
          return true if (period.hall & @new_period.hall).any?
        end
      end
    end

    def session_break(range)
      period(range) { session_break }
    end

    def check_holes(schedule)
      time_holes = []
      sorted_periods = schedule.sort_by { |period| period.range_time.begin }
      tested_period = [sorted_periods.shift]
      sorted_periods.each do |period|
        if tested_period.last.range_time.cover? period.range_time.begin
          # Если нет дырок в расписании, то просто заменяет один элемент в массиве
          tested_period[-1] = period
        else
          # Если дырка есть, то добавляет в массив элемент, перед которым есть дырка
          tested_period << period
        end
      end

      return if tested_period.length == 1
      tested_period.each_with_index do |p, i|
        # each_slice(2) не работает с нечетным кол-вом элементов в массиве
        # и не пропускает паузу между вторым и третьим элементом [p1, p2] [p3, p4]
        break if i == tested_period.length - 1
        from = to_time_string(p.range_time.end)
        to = to_time_string(tested_period[i+1].range_time.begin)
        time_holes << Range.new(from, to)
      end
      fail ArgumentError, "В расписании есть неучтенное время: #{time_holes.join(', ')}"
    end

    class Object::Range
      def overlaps?(range)
        # "11:00" not overlapping another "11:00"
        return false if range.last == first || range.first == last
        cover?(range.first) || range.cover?(first)
      end
    end

    class PeriodBuilder
      attr_accessor :period

      def initialize(range, &block)
        @period = ImdbPlayfield::SchedulePeriod.new(range)
        instance_eval(&block)
      end

      def method_missing(key, value)
        if ImdbPlayfield::MovieCollection::KEYS.any? { |k| k.to_sym == key }
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
    end
  end
end
