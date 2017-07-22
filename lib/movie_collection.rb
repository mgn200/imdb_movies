require 'csv'
require 'ostruct'
require 'date'
require 'pry'
require 'date'

module MovieProduction
  class MovieCollection
    include Enumerable
    KEYS = %w[link title year country date genre duration rating director actors].freeze

    attr_reader :all

    def initialize(file = 'movies.txt')
      @filename = file
      abort('No such file') unless File.exist? file
      @all = parse_file(file)
    end

    def sort_by(field)
      if field == :director
        puts sort_by { |x| x.director.split(' ').last }
      else
        puts sort_by { |x| x.send field }.map(&:to_s)
      end
    end

    def filter(hash)
      hash.reduce(self) do |sequence, (k, v)|
        sequence.select { |x| x.matches?(k, v) }
      end
    end

    def stats(field)
      flat_map(&field).group_by(&:itself).map { |val, group| [val, group.count] }.to_h
    end

    def has_genre?(genre)
      map(&:genre).flatten.uniq.include? genre
    end

    def pick_movie(movies_array)
      movies_array.sort_by { |x| x.rating.to_f * rand(1..1.5) }.last
    end

    private

    def parse_file(file)
      CSV.foreach(file, col_sep: '|', headers: KEYS).map do |row|
        year = row['year'].to_i
        case year
        when (1900..1945)
          AncientMovie.new(self, row.to_h)
        when (1946..1967)
          ClassicMovie.new(self, row.to_h)
        when (1968..1999)
          ModernMovie.new(self, row.to_h)
        when (2000..3000)
          NewMovie.new(self, row.to_h)
        end
      end
    end

    def each(&block)
      @all.each(&block)
    end
  end
end
