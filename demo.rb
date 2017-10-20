require 'csv'
require 'date'
require 'money'
require 'virtus'
require 'ostruct'
require_relative 'lib/tmdb_data/tmdb_api'
require_relative 'lib/haml_builder'
require_relative 'lib/time_helper'
require_relative 'lib/coercions'
require_relative 'lib/movie'
require_relative 'lib/movie_collection'
require_relative 'lib/cashbox'
require_relative 'lib/movies_dsl'
require_relative 'lib/netflix'
require_relative 'lib/netflix_reference'
require_relative 'lib/theatre_builder'
require_relative 'lib/schedule_period'
require_relative 'lib/theatre_schedule'
require_relative 'lib/theatre'
require_relative 'lib/ancient_movie'
require_relative 'lib/classic_movie'
require_relative 'lib/modern_movie'
require_relative 'lib/new_movie'
require_relative 'lib/schedule_line'
# netflix = MovieProduction::Netflix.new
# netflix.show { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003}
# netflix.define_filter(:test) { |movie| movie.director != 'David Fincher' && movie.year > 1999 }
# puts movies.stats :month
# puts movies.filter(genre: 'Comedy', year: 2011)
# puts movies.filter(actors: /Bob/)
# puts movies.filter(period: 'Ancient').count
# movies.sort_by :year
# movies.all.first.has_genre? ['Drama', 'Adventure']
# movies.all.first.has_genre? 'Dramdsa'
