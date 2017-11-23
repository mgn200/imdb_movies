module ImdbPlayfield
  class IMDBScrapper

    GEM_YML_FILE = File.join(File.dirname(File.expand_path("../../", __FILE__)), "data/movies_imdb_info.yml")
    USER_FILE = "data/movies_imdb_info.yml"

    class << self
      # ключи строго прописаны(бюджет)
      # тянет хтмл страницы всех фильмов из коллекции
      # сохранет данные о бюджете из этих страниц в yml

      # When scrapper is called by user - it always creates and uses user_file
      def run(movies_array = ImdbPlayfield::MovieCollection.new.all)
        FileUtils::mkdir_p("data/imdb_pages") unless File.exist? "data/imdb_pages"
        File.new(user_file, "w+") unless File.exist? "data/movies_imdb_info.yml"

        data = movies_array.map do |movie|
          store_locally(movie)
          [movie.imdb_id, { budget: parse_html_page(movie) }]
        end

        # When #run is called, it will always write fresh data to user's file
        File.write(USER_FILE, data.to_h.to_yaml)
      end

      def parse_html_page(movie)
        page = Nokogiri::HTML(open("#{pages_path}/#{movie.title}.html"))
        parent_element = page.at("div#titleDetails h3:contains('Box Office')")
        parent_element.next_element.text.match(%r{\$\S*}).to_s if parent_element
      end

      def store_locally(movie)
        return true if File.exist?("#{pages_path}/#{movie.title}.html")
        page_data = open(movie.link).read
        File.write("#{pages_path}/#{movie.title}.html", page_data)
      end

      def pages_path
        return File.expand_path("data/imdb_pages") if File.exist?("data/imdb_pages")
        File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/imdb_pages')
      end
    end
  end
end
