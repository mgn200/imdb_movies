#!/usr/bin/env ruby
# запрос к АПИ tmdb
require_relative '../lib/imdb_playfield'
ImdbPlayfield::TMDBApi.new.fetch_info
