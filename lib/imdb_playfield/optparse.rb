module ImdbPlayfield
  # Parses Netflix public methods
  class Optparse
    def self.parse(args)
      options = OpenStruct.new

      opt_parser = OptionParser.new do |opts|
        options.netflix = ImdbPlayfield::Netflix.new
        opts.banner = "Usage: netflix [options]"

        opts.on("--pay N", Integer,
                  "Put given money number to balance") do |money|

          options.netflix.pay money
        end

        opts.on("--show [FILTERS]", Array,
                "Filters movie collection and picks movie") do |filters|

          fail ArgumentError, 'Please specify filters' if filters.nil?
          movie_params = filters.map { |filter| filter.split(":") }.to_h
          movie_params.update(movie_params) do |key, value|
            case key
            when "year" || "duration"
              value.to_i
            when "rating"
              value.to_f
            else
              value
            end
          end
          options.movie = options.netflix.show(movie_params)
        end
      end
      opt_parser.parse!(args)
      p options.movie
    end
  end
end
