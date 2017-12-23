# Вытягивалка фильмов(информации по ним) и сохранялка их в файл
# делает запрос к апи tmdb, создает yml файл c информацией
# этот файл затем обрабатыватся TmdbYmlParser'ом, чтобы вытянуть доп. инфу по фильму

module ImdbPlayfield
  # Send api requests to tmdb.com api and saves provided
  # Data is later used to build index html page
  # @see ImdbPlayfield::HamlBuilder#build_html
  class TMDBApi
    # Tmdb api query string
    URL_PATTERN = "https://api.themoviedb.org/3/find/%s?api_key=%s&language=ru-RU&external_source=imdb_id"
    API_KEY = File.exist?('config.yml') ? YAML.load_file('config.yml')['ApiKey'] : nil
    # Absolute path to yml data file stored in gem
    GEM_YML_FILE = File.join(File.dirname(File.expand_path("../../", __FILE__)), "data/movies_tmdb_info.yml")
    # Path to user yml file, created when TMDBApi.run is called by user
    USER_FILE = "data/movies_tmdb_info.yml"

    class << self
      # When user calls #run, it saves info to local USER_FILE and used it instread of GEM_YML_FILE
      # @param data [Hash] of parsed response from tmdb api
      # @return [Integer] number of bytes written after calling File.write and creating a USER_FILE
      # @see ImdbPlayfield::TMDBApi::USER_FILE
      def save(data)
        File.write(USER_FILE, data.to_yaml)
      end

      # Pick imdb movie keys from movie collection. Query tmdb api(knows imdb movie ids)
      # and save data from response in USER_FILE.
      # @note
      #   when user calls #run it creates local file and uses them instead(USER_FILE) of
      #   the ones stored in gem(GEM_YML_FILE)
      # @param movies_collection [Array] of movies, default to ImdbPlayfield::MovieCollection.all
      # @see ImdbPlayfield::MovieCollection
      # @return [Integer] number of bytes written after writing yml file with response data(USER_FILE)
      def run(movies_collection = ImdbPlayfield::MovieCollection.new)
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

      # Send request to tmdp api, formatting query string with movie imdb id(tmdb knows these keys)
      # @see ImdbPlayfield::TMDBApi::URL_PATTERN
      # @see ImdbPlayfield::TMDBApi::API_KEY
      # @see ImdbPlayfield::MovieCollection#imdb_id
      # @param imdb_key [String] imdb movie id
      # @return [Net::HTTPResponse] object with body that contains additional movie info
      def send_request(imdb_key)
        url = format(URL_PATTERN, imdb_key, API_KEY)
        response = Net::HTTP.get_response(URI url)
      end
    end
  end
end
