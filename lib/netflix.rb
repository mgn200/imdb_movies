module MovieProduction
  class Netflix < MovieProduction::MovieCollection
    extend MovieProduction::Cashbox
    attr_reader :balance, :user_filters

    def initialize
      super
      @balance = Money.new(0)
      @user_filters = {}
    end

    def show(params = {}, &block)
      movies = filter(params, &block)
      raise ArgumentError, 'Wrong arguments' unless movies.any?
      movie = pick_movie(movies)
      raise 'Insufficient funds' unless (@balance - movie.price) >= 0
      @balance -= movie.price
      "Now showing: #{movie.title} #{start_end(movie)}"
    end

    def filter(params = {}, &block)
      filtered = block_given? ? select(&block) : all
      user_filter, movie_params = params.partition { |x| user_filters[x.first] }.map(&:to_h)

      filtered = user_filter.reduce(filtered) do |memo, (k, v)|
        block = user_filters[k]
        memo.select { |m| block.call(m, v) }
      end

      super(movie_params, filtered)
    end

    def pay(price)
      raise ArgumentError, 'Wrong amount' unless price > 0
      @balance += Money.new(price * 100) # to whole dollars
      Netflix.store_cash(price)
    end

    def how_much?(movie_name)
      raise ArgumentError, 'No such movie' unless filter(title: movie_name).any?
      filter(title: movie_name).first.price.format
    end

    def define_filter(filter_name, from: nil, arg: nil, &block)
      from && arg ? user_filters[filter_name] = proc { |m| user_filters[from].call(m, arg) } : user_filters[filter_name] = block
    end

    private

    def start_end(movie)
      start = Time.now.strftime("%T")
      ending = (Time.now + movie.duration * 60).strftime('%T')
      "#{start} - #{ending}"
    end
  end
end
