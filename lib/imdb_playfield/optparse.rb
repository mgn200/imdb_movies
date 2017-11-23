module ImdbPlayfield
  # Parses Netflix public methods
  class Optparse
    def self.parse(args)
      options = OpenStruct.new

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: netflix [options]"

        opts.on("--pay N", Integer,
                "Put given money number to balance") do |money|
          options.pay = money
        end

        opts.on("--show [FILTERS]", Array,
                "Filters movie collection and picks movie") do |filters|
          options.show = filters
        end
      end
    end
  end
end
