# Main namespace for ImdbPlayfield
# Used for loading all necessary classes in correct order
module ImdbPlayfield
  class << self
  # Requires internal ImdbPlayfield libraries.
  def require_libs(*libs)
    libs.each do |lib|
      require "#{lib_path}/#{lib}"
    end
  end

  require_libs "utils", "options", "connection", "rack_builder", "parameters",
               "middleware", "adapter", "request", "response", "upload_io", "error"

  end
end

#require 'csv'
#require 'date'
#require 'money'
#require 'virtus'
#require 'imdb_playfield/time_helper'
#require 'imdb_playfield/coercions'
#require 'imdb_playfield/movie'
#require 'imdb_playfield/ancient_movie'
#require 'imdb_playfield/classic_movie'
#require 'imdb_playfield/modern_movie'
#require 'imdb_playfield/new_movie'
#require 'imdb_playfield/movie_collection'
#require 'imdb_playfield/imdb_scrapper'
#require 'imdb_playfield/tmdb_api'
#require 'imdb_playfield/haml_builder'
#require 'imdb_playfield/cashbox'
#require 'imdb_playfield/movies_dsl'
#require 'imdb_playfield/netflix'
#require 'imdb_playfield/netflix_reference'
#require 'imdb_playfield/theatre_builder'
#require 'imdb_playfield/schedule_period'
#require 'imdb_playfield/theatre_schedule'
#require 'imdb_playfield/theatre'
#require 'imdb_playfield/schedule_line'
