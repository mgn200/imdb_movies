# Вытягивалка фильмов(информации по ним) и сохранялка их в файл
# делает запрос к апи tmdb, создает yml файл c информацией
# этот файл затем обрабатыватся TmdbYmlParser'ом, чтобы вытянуть доп. инфу по фильму

module ImdbPlayfield
  class TMDBApi
    URL_PATTERN = "https://api.themoviedb.org/3/find/%s?api_key=%s&language=ru-RU&external_source=imdb_id"
    API_KEY = File.exist?('config.yml') ? YAML.load_file('config.yml')['ApiKey'] : nil
    GEM_YML_FILE = File.join(File.dirname(File.expand_path("../../", __FILE__)), "data/movies_tmdb_info.yml")
    USER_FILE = "data/movies_tmdb_info.yml"

    class << self
      def save(data)
        # When user calls fetch_info, it saves info to local file and uses it instead
        File.write(USER_FILE, data.to_yaml)
      end
      # берет imdb ключи из коллекции мувиков
      # делаем запросы к tmdb api, который знате эти ключи
      # сохраняет данные в yml
      def run(movies_collection = ImdbPlayfield::MovieCollection.new)
        # when user runs request it creates local file and uses them instead of
        # the ones stored in gem
        File.new USER_FILE unless File.exist? USER_FILE
        @prepared_data = {}

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
end
