require 'ostruct'
module MovieProduction
  class SchedulePeriod
    include Enumerable
    include Virtus.model

    attribute :range_time
    attribute :filters
    attribute :daytime
    attribute :price
    attribute :hall
    attribute :description
    attribute :session_break, Boolean,:default => false

    def matches?(movie)
      @filters.all? { |k, v| movie.matches?(k, v) }
    end
  end
end
