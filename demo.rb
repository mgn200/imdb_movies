require 'date'
require 'csv'
require 'ostruct'
require 'pry'
require_relative 'movie.rb'

default_file = "movies.txt"
file = ARGV.first || default_file
abort('No such file') unless File.exist? file
puts "Using default file" if file == default_file

movies = MovieCollection.new(file)
#binding.pry
movies.all.first.has_genre? 'Drama'

movies.has_genre? 'Comedy'
movies.all.first.has_genre? 'Dramdsa'

# Testing
#movies.stats :month
#movies.filter(genre: 'Comedy', year: 2011)
#movies.sort_by :year
