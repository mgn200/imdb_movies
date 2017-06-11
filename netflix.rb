require 'pry'

class Netflix < MovieCollection
  attr_accessor :balance, :all

  def initialize(collection)
    @balance = 10
    @all = collection.all
  end

  def filter(params)
    super
  end

  def show(params)
    movie = filter(params).sample
    raise 'Insufficient funds' unless (@balance - movie.price) > 0
    @balance -= movie.price
    "Now showing: #{movie.title} #{start_end(movie)}"
  end

  def pay(amount)
    @balance += amount
  end

  def how_much?(movie_name)
    #@all.select blablabla
    filter({title: movie_name}).first.price
  end

  private

  def start_end(movie)
    start = Time.now.strftime("%T")
    ending = (Time.now + movie.duration * 60).strftime("%T")
    "#{start} - #{ending}"
  end
end
