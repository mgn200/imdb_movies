require 'csv'
require 'ostruct'
require 'date'
require 'pry'
require 'date'
require_relative 'ancient_movie'
require_relative 'classic_movie'
require_relative 'new_movie'
require_relative 'modern_movie'

class MovieCollection
  KEYS = %w[link title year country date genre duration rating director actors]

  attr_reader :all

  def initialize(file = 'movies.txt')
    @filename = file
    abort('No such file') unless File.exist? file
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
    hash.reduce(@all) do |sequence, (k, v)|
      sequence.select { |x| x.matches?(k, v) }
    end
  end

  def stats(field)
    @all.flat_map(&field).group_by(&:itself).map { |val, group| [val, group.count] }.to_h
  end

  def has_genre?(genre)
    @all.map(&:genre).flatten.uniq.include? genre
  end

  def pick_movie(movies_array)
    movies_array.sort_by { |x| x.rating.to_f*rand(1..1.5) }.last
  end

  private

  def parse_file(file)
    CSV.foreach(file, { col_sep: '|', headers: KEYS }).map do |row|
      year = row['year'].to_i
      case
      when year < 1945
        AncientMovie.new(self, row.to_h)
      when year >= 1945 && year < 1968
        ClassicMovie.new(self, row.to_h)
      when year >= 1968 && year < 2000
        ModernMovie.new(self, row.to_h)
      when year >= 2000
        NewMovie.new(self, row.to_h)
      end
    end
  end
end
