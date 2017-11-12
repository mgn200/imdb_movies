#!/usr/bin/env ruby
# запрос к АПИ tmdb
require_relative '../demo.rb'
require_relative '../lib/tmdb_api'
ImdbPlayfield::TMDBApi.new.fetch_info
