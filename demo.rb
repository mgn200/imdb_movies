require 'date'
require 'csv'
require 'ostruct'
require 'pry'
require_relative 'movie.rb'

movies = MovieCollection.new

puts movies.stats :month
#puts movies.filter(genre: 'Comedy', year: 2011)
#puts movies.filter(actors: /Bob/)
#puts movies.filter(year: 1999, actors: 'Brad Pitt')
#movies.sort_by :year
#movies.all.first.has_genre? 'Drama'
#movies.has_genre? 'Comedy'
#movies.all.first.has_genre? 'Dramdsa'
