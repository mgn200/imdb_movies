# Main namespace for ImdbPlayfield
# Used for loading all necessary classes in correct order
require 'nokogiri'
require 'money'
require 'virtus'
require 'haml'
require 'csv'
require 'pry'
require 'open-uri'
require 'net/http'
require 'thor'
require 'ostruct'

# Gem main namespace, with folder and files scaffold methods and main libs requiring
module ImdbPlayfield
  class << self
    # Gets or sets the path that the ImdbPlayfield libs are loaded from
    attr_accessor :lib_path
    self.lib_path = File.expand_path "../imdb_playfield", __FILE__

    # Requires internal ImdbPlayfield libraries
    # @param libs [Array] array of .rb libs in /lib/imdb_playfield/
    # @return [Array] required libraries
    def require_libs(*libs)
      libs.each do |lib|
        require "#{lib_path}/#{lib}"
      end
    end

    # Creates config.yml with API_KEY, needed to be run before building html or making any external
    # requests(TMDBApi or IMDBScrapper)
    # @return [String] with success message and config.yml file in current working folder
    def create_config
      config_sample_file = File.join(File.dirname(File.expand_path("../", __FILE__)), 'config.yml.sample')
      File.write('config.yml', File.read(config_sample_file))
      return "config.yml created, change API_KEY in that file to your tmdb's API key"
    end

    # Creates needed folder and files for TMDBApi and IDMBScrapper #run methods
    # @see ImdbPlayfield::TMDBApi#run
    # @see ImdbPlayfield::IMDBScrapper#run
    # @return [Array] of created files and folder
    def create_data_files
      FileUtils::mkdir_p('data/views')
      %w[data/movies_tmdb_info.yml data/movies_imdb_info.yml].each do |file_path|
           File.new(file_path, "w+")
      end
    end
  end


  # Requiring all the libraries needed in order for gem to work properly
  # Order of requiring does matter
  require_libs "cashbox", "version", "time_helper", "schedule_line", "coercions",
               "movie", "movie_collection", "haml_builder", "imdb_scrapper", "tmdb_api","netflix_dsl",
               "netflix_reference", "netflix", "schedule_period", "theatre_builder",
               "theatre_schedule", "theatre", "ancient_movie", "classic_movie", "modern_movie",
               "new_movie"
end
