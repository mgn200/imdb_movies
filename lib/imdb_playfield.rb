# Main namespace for ImdbPlayfield
# Used for loading all necessary classes in correct order
require 'money'
require 'virtus'
require 'haml'

module ImdbPlayfield
  # Public: Gets or sets the path that the ImdbPlayfield libs are loaded from
  class << self
    attr_accessor :lib_path

    # Requires internal ImdbPlayfield libraries.
    def require_libs(*libs)
      libs.each do |lib|
        require "#{lib_path}/#{lib}"
      end
    end

  end

  self.lib_path = File.expand_path "../imdb_playfield", __FILE__
  require_libs "cashbox", "version", "schedule_line", "time_helper", "coercions",
               "movie", "movie_collection", "tmdb_api", "netflix", "theatre", "netflix_reference",
               "netflix_dsl", "ancient_movie", "classic_movie", "modern_movie",
               "new_movie", "imdb_scrapper", "schedule_period", "theatre_builder",
               "theatre_schedule"

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
