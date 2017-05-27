require 'date'
require 'csv'
require 'ostruct'
require 'pry'
require_relative 'movie.rb'

movies = MovieCollection.new
#binding.pry
puts movies.all.first.has_genre? 'Drama'

#movies.has_genre? 'Comedy'
movies.all.first.has_genre? 'Dramdsa'

# Testing
#movies.stats :month
#puts movies.filter(genre: 'Comedy', year: 2011)
#movies.sort_by :year
