module ImdbPlayfield
  class IMDBScrapper
    # При запуске скрапера он всегда создаст этот файй
    YML_FILE_PATH = File.expand_path "data/movies_imdb_info.yml"
    # ключи строго прописаны(бюджет)
    # тянет хтмл страницы всех фильмов из коллекции
    # сохранет данные о бюджете из этих страниц в yml
    def self.run(movies_array = ImdbPlayfield::MovieCollection.new.all)
      FileUtils::mkdir_p("data/imdb_pages") unless File.exist? "data/imdb_pages"
      File.new("data/movies_imdb_info.yml", "w+") unless File.exist? "data/movies_imdb_info.yml"

      data = movies_array.map do |movie|
        store_locally(movie)
        [movie.imdb_id, { budget: parse_html_page(movie) }]
      end

      File.write(YML_FILE_PATH, data.to_h.to_yaml)
    end

    def self.parse_html_page(movie)
      page = Nokogiri::HTML(open("#{pages_path}/#{movie.title}.html"))
      parent_element = page.at("div#titleDetails h3:contains('Box Office')")
      parent_element.next_element.text.match(%r{\$\S*}).to_s if parent_element
    end

    def self.store_locally(movie)
      return true if File.exist?("#{pages_path}/#{movie.title}.html")
      page_data = open(movie.link).read
      File.write("#{pages_path}/#{movie.title}.html", page_data)
    end

    def self.pages_path
      return File.expand_path("data/imdb_pages") if File.exist?("data/imdb_pages")
      File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/imdb_pages')
    end
  end
end
