module MovieProduction
  # Собирает инфу по конкретному времени в расписании и печатает её
  class ScheduleLine
    attr_reader :movie, :hall
    def initialize(params)
      @time = params[:start]
      @movie = params[:movie]
      @hall = params[:halls]
    end

    def time
      return @time if @time.is_a? String
      to_time_string(@time)
    end

    def halls
      @hall.join(", ").capitalize
    end

    def print
      return "\t#{time} #{movie.title}(#{movie.genre.join(", ")}, #{movie.year})." +
      " #{halls} hall(s).\n"
    end
  end
end
