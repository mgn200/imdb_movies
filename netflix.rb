require 'pry'

class Netflix < MovieCollection
  attr_reader :balance

  def initialize
    super
    @balance = 0
  end

  def show(params)
    movies = filter(params)
    raise ArgumentError, 'Wrong arguments' unless movies.any?
    movie = pick_movie(movies)
    raise 'Insufficient funds' unless (@balance - movie.price) > 0
    @balance -= movie.price
    "Now showing: #{movie.title} #{start_end(movie)}"
  end

  def pay(amount)
    raise ArgumentError, 'Wrong amount' unless amount > 0
    @balance += amount
  end

  def how_much?(movie_name)
    raise ArgumentError, 'No such movie' unless filter(title: movie_name).any?
    filter({title: movie_name}).first.price
  end

  private

  def start_end(movie)
    start = Time.now.strftime("%T")
    ending = (Time.now + movie.duration * 60).strftime("%T")
    "#{start} - #{ending}"
  end
end
