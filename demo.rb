require 'date'
require 'csv'
require 'ostruct'
require 'pry'
require './theatre.rb'
require './movie.rb'
require './movie_collection.rb'
require './netflix.rb'
#binding.pry

netflix = MovieProduction::Netflix.new
netflix.show { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003}
#netflix.define_filter(:test) { |movie| movie.director != 'David Fincher' && movie.year > 1999 }
#netflix.define_filter(:test) { |movie| movie.director != 'David Fincher' && movie.year > 1999 }
#puts movies.stats :month
#puts movies.filter(genre: 'Comedy', year: 2011)
#puts movies.filter(actors: /Bob/)
#puts movies.filter(period: 'Ancient').count
#movies.sort_by :year
#movies.all.first.has_genre? ['Drama', 'Adventure']
#movies.all.first.has_genre? 'Dramdsa'
