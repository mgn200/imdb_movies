module ImdbPlayfield
  class IMDBScrapper
    PAGES_PATH = File.expand_path("lib/imdb_pages")
    YML_FILE_PATH = File.expand_path("lib/imdb_data/movies_imdb_info_yml")
    # ключи строго прописаны(бюджет)
    # тянет хтмл страницы всех фильмов из коллекции
    # сохранет данные о бюджете из этих страниц в yml
    def self.run(movies_array = MovieProduction::MovieCollection.new.all)
      data = movies_array.map do |movie|
        store_locally(movie)
        [movie.imdb_id, {budget: parse_html_page(movie)}]
      end

      File.write(YML_FILE_PATH, data.to_h.to_yaml)
    end

    def self.parse_html_page(movie)
      page = Nokogiri::HTML(open("#{PAGES_PATH}/#{movie.title}.html"))
      parent_element = page.at("div#titleDetails h3:contains('Box Office')")
      parent_element.next_element.text.match(%r{\$\S*}).to_s if parent_element
    end

    def self.store_locally(movie)
      return true if File.exist?("#{PAGES_PATH}/#{movie.title}.html")
      page_data = open(movie.link).read
      File.write("#{PAGES_PATH}/#{movie.title}.html", page_data)
    end
  end
end
#require 'open-uri'
#require 'nokogiri'
#require 'yaml'
