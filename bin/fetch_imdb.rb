# fetch budget for whole MovieCollection
require_relative '../demo.rb'
require_relative '../lib/imdb_scrapper'
TMDBApi.new.fetch_info
