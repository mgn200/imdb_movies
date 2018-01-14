module ImdbPlayfield
  # Class prints information about particular schedule period.
  # @see SchedulePeriod #schedule_line
  class ScheduleLine
    include ImdbPlayfield::TimeHelper

    attr_reader :movie, :hall

    def initialize(params)
      @time = params[:start]
      @movie = params[:movie]
      @hall = params[:halls]
    end

    # Formats time to "09:00" Format
    # @see TimeHelper #to_time_string
    def time
      return @time if @time.is_a? String
      to_time_string(@time)
    end

    # Formats halls
    def halls
      @hall.join(", ").capitalize
    end

    # Print one schedule period
    # @see Theatre #info
    # @return [String] with time period when movie is being showed and movie information
    def print
      return "\t#{time} #{movie.title}(#{movie.genre.join(", ")}, #{movie.year})." +
      " #{halls} hall(s).\n"
    end
  end
end
