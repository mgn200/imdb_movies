require 'pry'

module Movieproduction

  class Netflix < Movieproduction::MovieCollection
    extend Movieproduction::Cashbox
    attr_reader :balance

    def initialize
      super
      @balance = Money.new(0)
    end

    def show(params)
      movies = filter(params)
      raise ArgumentError, 'Wrong arguments' unless movies.any?
      movie = pick_movie(movies)
      raise 'Insufficient funds' unless (@balance - movie.price) > 0
      @balance -= movie.price
      "Now showing: #{movie.title} #{start_end(movie)}"
    end

    def pay(price)
      raise ArgumentError, 'Wrong amount' unless price > 0
      @balance += Money.new(price*100) #to whole dollars
      Netflix.store_cash(price)
    end

    def how_much?(movie_name)
      raise ArgumentError, 'No such movie' unless filter(title: movie_name).any?
      filter({title: movie_name}).first.price.format
    end

    private

    def start_end(movie)
      start = Time.now.strftime("%T")
      ending = (Time.now + movie.duration * 60).strftime("%T")
      "#{start} - #{ending}"
    end
  end
end
