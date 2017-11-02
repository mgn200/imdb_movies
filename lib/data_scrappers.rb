require 'ostruct'
require 'open-uri'
require 'nokogiri'

module MovieProduction
  module Scrappers
    # get info from prepared YML file from themoviedb api
    class Tmdb
      def self.run(movie, *keys)
        raise ArgumentError, 'Укажите, какие доп. параметры нужно получить.' if keys.empty?
        keys.map!(&:to_s)
        data = YAML.load_file(TMDBApi::YML_FILE_PATH)
        raise StandartError, 'В файле нет данных. Запустите скрипт TMDBApi, чтобы собрать информацию.' if data.empty?
        attributes = data.find { |hash| hash.has_key? movie.imdb_id }[movie.imdb_id]
                         .select { |k, | keys.include? k }

      end
    end
    # get info from raw html imdb movie page
    class Imdb
      PAGES_PATH = "/home/pfear/projects/imdb_movies/lib/imdb_pages"
      # ключи пока строго прописаны(бюджет)
      def self.run(movie, keys = nil)
        if File.exist?("#{PAGES_PATH}/#{movie.title}.html")
          page = Nokogiri::HTML(open("#{PAGES_PATH}/#{movie.title}.html"))
        else
          new_file = File.new("#{PAGES_PATH}/#{movie.title}.html", 'w')
          open(new_file, 'w') do |file|
            open("#{movie.link}") do |uri|
               file.write(uri.read)
            end
          end
          page = Nokogiri::HTML(open("#{PAGES_PATH}/#{movie.title}.html"))
        end
        # Не во всех фильмах есть бюджет + не получается вычленить его по селектору, т.к. это plain text
        # вне каких либо тегов
        parent_element = page.at("div#titleDetails h3:contains('Box Office')")
        budget = parent_element.nil? ? 'unknown budget' : parent_element.next_element.text.match(%r{\$\S*}).to_s
        { budget: budget }
      end
    end
  end
end
