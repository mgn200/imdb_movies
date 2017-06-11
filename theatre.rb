require 'pry'

class Theatre < MovieCollection
  attr_accessor :balance, :all

  def initialize(collection)
    @balance = 10
    @all = collection.all
  end

  def filter(params)
    super
  end

  def show(time)
    params = get_period(time)
    binding.pry
    movie = filter(params).sample
    raise 'Insufficient funds' unless (@balance - movie.price) > 0
    @balance -= movie.price
    "#{movie.title} will be shown at #{time}"
  end

  def get_period(time)
    case time
    when "06:00".."12:00"
      { period: 'Ancient' }
    when "12:00".."18:00"
      { genre: 'Comedy,Adventure' }
    when "18:00".."24:00"
      { genre: 'Drama,Horror' }
    end
  end
end
