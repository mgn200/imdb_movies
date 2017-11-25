namespace :get_movie_data do
  desc 'TMDB'
  task :fetch_tmdb_info do
    ImdbPlayfield::TMDBApi.run
  end

  task :fetch_imdb_info do
    ImdbPlayfield::IMDBScrapper.run
  end

  task :fetch_all do
    ImdbPlayfield::TMDBApi.run
    ImdbPlayfield::IMDBScrapper.run
  end
end
