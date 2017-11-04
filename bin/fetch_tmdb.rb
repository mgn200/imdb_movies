# Вытягивалка фильмов(информации по ним) и сохранялка их в файл
require 'pry'
require 'uri'
require 'net/http'
require 'json'
require 'yaml'
require 'progressbar'
require_relative '../demo.rb'
# делает запрос к апи tmdb, создает yml файл c информацией
# этот файл затем обрабатыватся TmdbYmlParser'ом, чтобы вытянуть доп. инфу по фильму
class TMDBApi
  YML_FILE_PATH = "/home/pfear/projects/imdb_movies/lib/tmdb_data/movies_tmdb_info.yml"
  # как скрыть?
  API_KEY = "63610838faff3554e990e04c5edb3ed3"

  def save(yml_filename = YML_FILE_PATH, data)
    # change yml_filename for testing
    File.open(yml_filename, 'w+') do |file|
      file.write data.to_yaml
    end
  end

  def imdb_keys
    # Создает массив уникальных id'шников фильмов на IMDB
    # API TMDB знает эти айдишники
    MovieProduction::MovieCollection.new.map(&:imdb_id)
  end

  def fetch_info
    prepared_data = {}
    imdb_keys.each do |imdb_key|
      response = send_request(imdb_key)
      result = JSON.parse(response.body)["movie_results"].first
      prepared_data[imdb_key] = result
    end
    save(prepared_data)
  end

  def send_request(imdb_key)
    uri = URI("https://api.themoviedb.org/3/find/#{imdb_key}?api_key=#{API_KEY}&language=ru-RU&external_source=imdb_id")
    response = Net::HTTP.get_response(uri)
  end
end

TMDBApi.new.fetch_info
