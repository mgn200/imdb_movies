module ImdbPlayfield
  # Imdb.com data scrapper.
  # Gets budget info for every movie provided in array.
  class IMDBScrapper
    GEM_YML_FILE = File.join(File.dirname(File.expand_path("../../", __FILE__)), "data/movies_imdb_info.yml")
    USER_FILE = "data/movies_imdb_info.yml"

    class << self
      # Absolute path to file with additional movie info about budget(movies_imdb_info.yml).
      # Used in {Movie}, providing additional movie information.
      # Returns either defaul pre-made gem data file ({G  EM_YML_FILE})
      # or user-created file, if it exists ({USER_FILE}).
      # @return [String] absolute path to imdb_movie_info.yml
      def imdb_yml_file
        return File.expand_path(ImdbPlayfield::IMDBScrapper::USER_FILE) if File.exist?(ImdbPlayfield::IMDBScrapper::USER_FILE)
        ImdbPlayfield::IMDBScrapper::GEM_YML_FILE
      end

      # Main class method, starts scrapping process and saves result to yml file.
      # @note
      #   Creates data/imdb_pages folder with with raw html movie pages from imdb.com
      #   Stores data with movies imdb id and it's budget in data/movies_imdb_info.yml file
      # @param movies_array [Array<AncientMovie, ModernMovie, NewMovie, ClassicMovie>] array of movies
      # @return [Boolean] true if file with movie budget data was successfully created
      def run(movies_array = ImdbPlayfield::MovieCollection.new.all)
        FileUtils::mkdir_p("data/imdb_pages") unless File.exist? "data/imdb_pages"
        File.new(user_file, "w+") unless File.exist? "data/movies_imdb_info.yml"

        data = movies_array.map do |movie|
          store_locally(movie)
          [movie.imdb_id, { budget: parse_html_page(movie) }]
        end

        File.write(USER_FILE, data.to_h.to_yaml)
        true
      end

      # Parses web page with nokogiri and fetches budget info
      # @param movie [AncientMovie, ModernMovie, NewMovie, ClassicMovie] Movie kind
      # @return [String, nil] budget string or nil if not found
      def parse_html_page(movie)
        page = Nokogiri::HTML(open("#{pages_path}/#{movie.title}.html"))
        parent_element = page.at("div#titleDetails h3:contains('Box Office')")
        parent_element.next_element.text.match(%r{\$\S*}).to_s if parent_element
      end

      # Saves raw html pages locally
      # @param movie [AncientMovie, ModernMovie, NewMovie, ClassicMovie] Movie kind
      # @return [true] if page successfully saved locally
      def store_locally(movie)
        return true if File.exist?("#{pages_path}/#{movie.title}.html")
        page_data = open(movie.link).read
        File.write("#{pages_path}/#{movie.title}.html", page_data)
        true
      end

      # Contains absolute path to data/imdb_pages, where raw html pages are stored
      # @note
      #   Points to gem local path if scrapper was never run by user.
      #   If #run is called by user, creates data/imdb_pages in current folder and uses it in the future.
      # @return [String] absolute filepath to data/imdb_pages
      def pages_path
        return File.expand_path("data/imdb_pages") if File.exist?("data/imdb_pages")
        File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/imdb_pages')
      end
    end
  end
end
