# Обращается к TMDB по api
# Тянет данные о постере и переводе фильмов из нашего файла
# Сохраняет данные в YAML
require 'pry'
require 'uri'
require 'net/http'
require 'json'
require 'yaml'
require 'progressbar'

class TMDBApi
  MOVIES_FILE = '/home/pfear/projects/imdb_movies/movies.txt'
  # как скрыть?
  API_KEY = "63610838faff3554e990e04c5edb3ed3"

  attr_reader :yml_file

  def initialize(yml_file_path = "/home/pfear/projects/imdb_movies/lib/tmdb_data/movies_info.yml")
    # чтобы была возможность изменить файл для тестов
    @yml_file = yml_file_path
    File.new(@yml_file, "w+")
  end

  def imdb_keys
    # Создает массив уникальных id'шников фильмов на IMDB
    # API TMDB знает эти айдишники
    array = []
    # use regex?
    File.read(MOVIES_FILE).each_line { |line| array << line.split("|").first.split("/")[4] }
    array
  end

  def fetch_info
    prepared_data = []
    imdb_keys.sample(2).each do |imdb_key|
      response = send_request(imdb_key)
      result = JSON.parse(response.body)["movie_results"].first
      prepared_data << { imdb_key => result }
    end
    write_yml(prepared_data)
    "OK"
  end

  def send_request(imdb_key)
    uri = URI("https://api.themoviedb.org/3/find/#{imdb_key}?api_key=#{API_KEY}&language=ru-RU&external_source=imdb_id")
    response = Net::HTTP.get_response(uri)
  end

  def write_yml(array_of_json)
    File.open(@yml_file, 'a') do |file|
      file.write array_of_json.to_yaml
    end
  end
end

#TMDBApi.new.fetch_info
