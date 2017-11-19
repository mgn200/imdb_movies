# Main namespace for ImdbPlayfield
# Used for loading all necessary classes in correct order
require 'nokogiri'
require 'money'
require 'virtus'
require 'haml'
require 'csv'
require 'money'
require 'pry'
require 'open-uri'
#require 'net/http'

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

    def create_config
      config_sample_file = File.join(File.dirname(File.expand_path("../", __FILE__)), 'config.yml.sample')
      File.write('config.yml', File.read(config_sample_file))
      return "config.yml created, change API_KEY in that file to your tmdb's API key"
    end

    def create_data_files
      FileUtils::mkdir_p('data/views')
      %w[data/movies_tmdb_info.yml data/movies_imdb_info.yml].each do |file_path|
           File.new(file_path, "w+")
      end
    end
  end

  self.lib_path = File.expand_path "../imdb_playfield", __FILE__

  # Order does matter
  require_libs "cashbox", "version", "schedule_line", "time_helper", "coercions",
               "movie", "movie_collection", "haml_builder", "imdb_scrapper", "tmdb_api","netflix_dsl",
               "netflix_reference", "netflix", "schedule_period", "theatre_builder",
               "theatre_schedule", "theatre", "ancient_movie", "classic_movie", "modern_movie",
               "new_movie"

end
