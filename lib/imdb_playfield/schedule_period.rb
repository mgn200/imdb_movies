module ImdbPlayfield
  # Class that build schedule period in Theatre schedule
  # Picks appropriate movies that will be showed
  # @see TheatreSchedule
  class SchedulePeriod
    include Enumerable
    include Virtus.model

    attribute :range_time, Coercions::RangeInSeconds
    attribute :filters
    attribute :price
    attribute :hall
    attribute :description

    # Override Virtus #initialize to properly work with time parameter
    def initialize(time, **options)
      super(options.merge(range_time: time))
    end

    # Check if movie matches schedule filters
    # @param movie [AncientMovie, ModernMovie, NewMovie, ClassicMovie] movie title
    # @return [Boolean] true if given movie matches schedule filters
    def matches?(movie)
      @filters.all? { |k, v| movie.matches?(k, v) }
    end

    # Picks and stacks movies into range period, while
    # @param range [Range] period range time
    # @param filters [Hash] hash of movie parameters accepted in current period
    # @param timeleft [Integer] number of "airtime" available in current period
    # @return [ScheduleLine] one period of schedule with picked movies that are going to be showed
    # @see ImdbPlayfield::ScheduleLine


    # Length of self(current period) in minutes
    def period_length
      ((range_time.first - range_time.last) / 60).abs.to_i
    end
  end
end
