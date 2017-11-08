#!/usr/bin/env ruby
# запрос к АПИ tmdb
require_relative '../demo.rb'
require_relative '../lib/tmdb_api'
TMDBApi.new.fetch_info
