module ImdbPlayfield
  # A DSL for Theatre that allows to create Theatre object with particular schedule
  # @example
  #   theater =
  #     Theater.new do
  #       hall :red, title: 'Красный зал', places: 100
  #       hall :blue, title: 'Синий зал', places: 50
  #       hall :green, title: 'Зелёный зал (deluxe)', places: 12
  #
  #     period '09:00'..'11:00' do
  #       description 'Утренний сеанс'
  #       filters genre: 'Comedy', year: 1900..1980
  #       price 10
  #       hall :red, :blue
  #     end
  #
  #     period '11:00'..'16:00' do
  #       description 'Спецпоказ'
  #       title 'The Terminator'
  #       price 50
  #       hall :green
  #     end
  #
  #     period '16:00'..'20:00' do
  #       description 'Вечерний сеанс'
  #       filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
  #       price 20
  #       hall :red, :blue
  #     end
  #
  #     period '19:00'..'22:00' do
  #       description 'Вечерний сеанс для киноманов'
  #       filters year: 1900..1945, exclude_country: 'USA'
  #       price 30
  #       hall :green
  #     end
  #   end
  module TheatreBuilder
    include ImdbPlayfield::TimeHelper

    # Building halls
    def hall(name, params)
      halls[name] = params
    end

    # Describing and building periods. Adds them to Theatres schedule.
    # @param new_range [Range] time range of future schedule period
    # @param block [&block] block with data describing future period
    # @return [Hash] a hash of user defined theatre schedule
    # @see ImdbPlayfield::PeriodBuilder
    def period(new_range = nil, &block)
      #range_in_seconds = to_seconds(new_range.first)..to_seconds(new_range.last) if new_range
      @schedule = [] if schedule == ImdbPlayfield::Theatre::DEFAULT_SCHEDULE
      @new_period = PeriodBuilder.new(new_range, &block).period
      fail ArgumentError, 'Periods and halls intersection detected. Please check parameters.' if intersection?(new_range)
      schedule << @new_period
    end

    # Check if time range intersects with other period time ranges in theatre schedule
    # @param new_range [Range] a range that will be checked with other
    # @return [Boolean] true if no intersection found
    def intersection?(new_range)
      # skip to second elemesnt for comparison
      return false if schedule.empty?
      schedule.any? do |period|
        if period.range_time.overlaps? range_in_seconds(new_range)
          return true if (period.hall & @new_period.hall).any?
        end
      end
    end

    # Insert official break between schedule periods
    def session_break(range)
      period(range) { session_break }
    end

    # Check if there are any holes between schedule periods
    # @param schedule [Array] Theatre schedule, default one or user defined.
    # @return [Boolean, ArgumentError] true if no holes, error if any
    # @see ImdbPlayfield::Theatre#initialize
    def check_holes(schedule)
      time_holes = []
      sorted_periods = schedule.sort_by { |period| period.range_time.begin }
      tested_period = [sorted_periods.shift]
      sorted_periods.each do |period|
        if tested_period.last.range_time.cover? period.range_time.begin
          # If there are no holes, overwrite element in array
          tested_period[-1] = period
        else
          # If there is a hall, add previous period to array
          tested_period << period
        end
      end

      return true if tested_period.length == 1
      tested_period.each_with_index do |p, i|
        # each_slice wont work with odd number of elements in array
        break if i == tested_period.length - 1
        from = to_time_string(p.range_time.end)
        to = to_time_string(tested_period[i+1].range_time.begin)
        time_holes << Range.new(from, to)
      end
      fail ArgumentError, "В расписании есть неучтенное время: #{time_holes.join(', ')}"
    end

    class Object::Range
      # Expands Ruby Range class with Rails-like method that checks ranges overlapping
      def overlaps?(range)
        # "11:00" not overlapping another "11:00"
        return false if range.last == first || range.first == last
        cover?(range.first) || range.cover?(first)
      end
    end

    # Service class that builds period and populates it with attributes from given block.
    # @see ImdbPlayfield::TheatreBuilder#period
    # @see ImdbPlayfield::SchedulePeriod
    class PeriodBuilder
      attr_accessor :period

      def initialize(range, &block)
        @period = ImdbPlayfield::SchedulePeriod.new(range)
        instance_eval(&block)
      end

      # Dynamically create schedule attributes from given &block.
      # @see ImdbPlayfield::TheatreBuilder::PeriodBuilder#initialize
      # @param key [Symbol] key from provided block of code
      # @param value [Numeric, String, Hash, Date] value to attach to provided key
      # @return [Hash] one schedule period that is added to schedule in Theatre
      def method_missing(key, value)
        if ImdbPlayfield::MovieCollection::KEYS.any? { |k| k.to_sym == key }
        # wrap params in filter, when they are given out of hash
        # i.e. { title: 'abc' } instead of { filters: { title: 'abc' } }
          @period.attributes = { filters: { key => value } }
        else
          @period.attributes = { key => value }
        end
      end

      # Add halls to the schedule.
      def hall(*halls)
        @period.hall = halls
      end
    end
  end
end
