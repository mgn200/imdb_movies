require 'pry'

class Netflix < MovieCollection
  attr_reader :all, :balance

  def initialize(collection)
    @balance = 0
    @all = collection.all
  end

  def show(params)
    movies = filter(params)
    movie = pick_movie(movies)
    raise 'Insufficient funds' unless (@balance - movie.price) > 0
    @balance -= movie.price
    "Now showing: #{movie.title} #{start_end(movie)}"
  end

  def pay(amount)
    @balance += amount
  end

  def how_much?(movie_name)
    filter({title: movie_name}).first.price
  end

  private

  def start_end(movie)
    start = Time.now.strftime("%T")
    ending = (Time.now + movie.duration * 60).strftime("%T")
    "#{start} - #{ending}"
  end
end
