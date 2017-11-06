require 'open-uri'
require 'nokogiri'
require 'yaml'
class IMDBScrapper
  PAGES_PATH = "/home/pfear/projects/imdb_movies/lib/imdb_pages"
  YML_FILE_PATH = "/home/pfear/projects/imdb_movies/lib/imdb_data/movies_imdb_info.yml"
  # ключи строго прописаны(бюджет)
  # тянет хтмл страницы всех фильмов из коллекции
  # сохранет данные о бюджете из этих страниц в yml
  def self.run(movies_array)
    data = {}
    movies_array.each do |movie|
      data["#{movie.imdb_id}"] = { budget: parse_html_page(movie) }
    end

    File.open(YML_FILE_PATH, "w+") { |file| file.write data.to_yaml }
  end

  def self.parse_html_page(movie)
    if !File.exist?("#{PAGES_PATH}/#{movie.title}.html")
      page_data = open(movie.link).read
      File.open("#{PAGES_PATH}/#{movie.title}.html", 'w+') { |f| f.write page_data }
    end

    page = Nokogiri::HTML(open("#{PAGES_PATH}/#{movie.title}.html"))
    parent_element = page.at("div#titleDetails h3:contains('Box Office')")
    parent_element.nil? ? nil : parent_element.next_element.text.match(%r{\$\S*}).to_s
  end
end
