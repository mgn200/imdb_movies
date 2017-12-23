module ImdbPlayfield
  # Representation of online movie theatre "netflix"
  class Netflix < ImdbPlayfield::MovieCollection
    # Cash is class variable in Netflix
    # @see Cashbox
    extend ImdbPlayfield::Cashbox
    include ImdbPlayfield::NetflixDSL
    attr_reader :balance, :user_filters

    # Set balance and user_filters variables.
    # Builds attribute filters used by NetflixDSL.
    # @see NetflixDSL
    def initialize
      super
      @balance = Money.new(0)
      @user_filters = {}
      make_attr_filters(KEYS)
    end

    # Request to pick and show movie based on params
    # @note
    #   You can access more advanced params if you use block, and even save it in custom filter
    # @see Netflix#define_filter
    # @param params [Hash] basic params in hash
    # @param block [&block] advanced params given in block
    # @example
    #   netflix.show { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003} => String
    #   netflix.show(genre: 'Comedy') => String
    #   netflix.show(user_filter: true) => String
    # @return [String] with picker movie and time period in which it will be showed
    def show(params = {}, &block)
      movies = filter(params, &block)
      raise ArgumentError, 'Wrong arguments, or no such movies can be found' unless movies.any?
      movie = pick_movie(movies)
      raise 'Insufficient funds' unless (@balance - movie.price) >= 0
      @balance -= movie.price
      "Now showing: #{movie.title} #{start_end(movie)}"
    end

    # An overwrite of MovieCollection #filter. Returns filtered array of movies
    # Works with blocks, hash params and defined user filters
    # @param hash [Hash] normal params or user filters and optional block
    # @param block [&block] block with filter arguments
    # @return [Array] movies filtered by given params
    def filter(params = {}, &block)
      filtered = block_given? ? select(&block) : all
      user_filter, movie_params = params.partition { |x| user_filters[x.first] }.map(&:to_h)
      filtered = user_filter.reduce(filtered) do |memo, (k, v)|
        block = user_filters[k]
        memo.select { |m| block.call(m, v) }
      end

      super(movie_params, filtered)
    end

    # Puts money on "account" to be able to buy and watch movie via #show method
    # @param price [Integer] money amount, will be converted to Money objects
    # @return [Money] object with integer converted into USD cents
    # @example
    #   "pay 25" will store money object as Money(:USD => 2500)
    def pay(price)
      raise ArgumentError, 'Wrong amount' unless price > 0
      @balance += Money.new(price * 100) # to whole dollars
      Netflix.store_cash(price)
    end

    # Returns price of the movie
    # @param movie_name [String] movie title
    # @return [String] "3.00$" or other price
    def how_much?(movie_name)
      raise ArgumentError, 'No such movie' unless filter(title: movie_name).any?
      filter(title: movie_name).first.price.format
    end

    # Saves custom user filter that can be used later.
    # @see Netflix#show
    # @note
    #   You can create new filters and filters based on another filters and their arguments.
    # @example
    #   netflix.define_filter(:new_sci_fi) { |movie, year| movie.year > year && ... }
    #   netflix.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014)
    # @param filter_name [Symbol] new filters name
    # @param from [Symbol] filter upon which you build a new one
    # @param arg [Numeric, String, Date] value to be changed in new filter
    # @param block [&block] block of code with filter arguments
    # @return [Proc] stored in user_filters
    # @see Netflix#user_filters
    def define_filter(filter_name, from: nil, arg: nil, &block)
      from && arg ? user_filters[filter_name] = proc { |m| user_filters[from].call(m, arg) } : user_filters[filter_name] = block
    end

    # Build an html page with HamlBuilder#build_html
    # @see HamlBuilder#build_html
    # @params [builder, movie_collection] builder class and movie collection
    # @return [Boolean] true if 'index.html' was created in data/views/index.html
    def build_html(builder, movie_collection = all)
      builder.new(movie_collection).build_html
    end

    private

    # Returns when movie will start and when will it end
    # Used in #show
    # @see Netflix#show
    # @param movie [AncientMovie, ModernMovie, NewMovie, ClassicMovie] movie object
    # @return [String] with time period from now till movie end
    def start_end(movie)
      start = Time.now.strftime("%T")
      ending = (Time.now + movie.duration * 60).strftime('%T')
      "#{start} - #{ending}"
    end
  end
end
