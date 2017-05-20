require 'csv'
require 'ostruct'
require 'date'
require 'pry'

class MovieCollection
  KEYS = %w[link title year country detailed_year genre duration rating director main_actors]
  attr_reader :all

  def initialize(file)
    @all = parse_file(file)
  end

  def sort_by(field)
    if field == :director
      puts @all.sort_by{ |x| x.director.split(' ').last }
    else
      puts @all.sort_by { |x| x.send field }.map(&:to_s)
    end
  end

  def filter(hash)
    key = hash.keys.first
    value = hash.values.first
    puts @all.select {|x| (x.send(key)).include? value}
  end

  def stats(field)
    #возвращает хэш: имя_дира - значение, имя_дира - кол-во
    puts @all.map(&field)
  end

  private

  def parse_file(file)
    CSV.foreach(file, { col_sep: '|', headers: KEYS }).map { |row| Movie.new(row.to_h) }
  end
end

