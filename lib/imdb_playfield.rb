# Main namespace for ImdbPlayfield.
# Used for loading all necessary classes in correct order.
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

# Gem main namespace, with folder and files scaffold methods and main libs requiring.
module ImdbPlayfield
  # Path ImdbPlayfield libs are loaded from.
  LIB_PATH = File.expand_path "../imdb_playfield", __FILE__

  class << self
    # Creates config.yml with API_KEY. Must be run before building html(HamlBuilder#build_html)
    # or making any external requests(TMDBApi or IMDBScrapper).
    # @return [String] with success message and config.yml file in current working folder
    def create_config
      config_sample_file = File.join(File.dirname(File.expand_path("../", __FILE__)), 'config.yml.sample')
      File.write('config.yml', File.read(config_sample_file))
      return "config.yml created, change API_KEY in that file to your tmdb's API key"
    end

    # Creates folder and files required for TMDBApi and IDMBScrapper #run methods.
    # @see ImdbPlayfield::TMDBApi#run
    # @see ImdbPlayfield::IMDBScrapper#run
    # @return [Array] of created files and folder
    def create_data_files
      FileUtils::mkdir_p('data/views')
      %w[data/movies_tmdb_info.yml data/movies_imdb_info.yml].each do |file_path|
           FileUtils.touch(file_path)
      end
    end
  end

  # Requiring needed gem libraries.
  # Order of requiring does matter.
  %w[cashbox version time_helper schedule_line coercions
     movie movie_collection haml_builder imdb_scrapper tmdb_api netflix_dsl
     netflix_reference netflix schedule_period theatre_builder theatre_schedule
     theatre ancient_movie classic_movie modern_movie new_movie].each do |lib|
       require "#{LIB_PATH}/#{lib}"
     end

end
