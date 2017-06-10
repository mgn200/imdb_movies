require 'pry'

class Netflix < MovieCollection
  attr_accessor :balance

  def initialize(collection)
    @balance = 0
    @all = collection.all
  end

  def filter(params)
    super
  end

  def show(params)
    movie = filter(params).sample
    "Now showing: #{movie.title} #{start_end(movie)}"
  end

  private

  def start_end(movie)
    start = Time.now.strftime("%T")
    ending = (Time.now + movie.duration * 60).strftime("%T")
    "#{start} - #{ending}"
  end
end
