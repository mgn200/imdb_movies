# Вытягивалка фильмов(информации по ним) и сохранялка их в файл
# делает запрос к апи tmdb, создает yml файл c информацией
# этот файл затем обрабатыватся TmdbYmlParser'ом, чтобы вытянуть доп. инфу по фильму
module ImdbPlayfield
  class TMDBApi
    YML_FILE_PATH = File.expand_path("lib/tmdb_data/movies_tmdb_info.yml")
    URL_PATTERN = "https://api.themoviedb.org/3/find/%s?api_key=%s&language=ru-RU&external_source=imdb_id"
    API_KEY = YAML.load_file('config.yml')['ApiKey']

    def initialize
      @prepared_data = {}
    end

    def save(data)
      File.write(YML_FILE_PATH, data.to_yaml)
    end
    # берет imdb ключи из коллекции мувиков
    # делаем запросы к tmdb api, который знате эти ключи
    # сохраняет данные в yml
    def fetch_info(movies_collection = ImdbPlayfield::MovieCollection.new)
      imdb_keys = movies_collection.map(&:imdb_id)
      imdb_keys.each do |imdb_key|
        response = send_request(imdb_key)
        result = JSON.parse(response.body)["movie_results"].first
        @prepared_data[imdb_key] = result
      end
      save(@prepared_data)
    end

    def send_request(imdb_key)
      url = format(URL_PATTERN, imdb_key, API_KEY)
      response = Net::HTTP.get_response(URI url)
    end
  end
end

#require 'uri'
#require 'net/http'
#require 'json'
#require 'yaml'
