require 'haml'
require 'pry'

module MovieProduction
  # Создает html-шаблон по мувикам
  class HamlBuilder
    HTML_FILE = "views/index.html"

    def initialize(movies_array = MovieProduction::MovieCollection.new)
       # разбиваем фильмы на субмассивы по две штуки
       # один массив - один ряд фильмов d представлении(два наименования в однои ряде бутстрап сетки)
       # для каждого фильма тянем доп. инфу?(тесты тормозят здесь, если вкидывать все 250 фильмов)
       @movies_row = movies_array.each_slice(2).to_a
    end

    def build_html
      # берет мувик и по каждому атриюуту создаёт строку
      # создает готовый  html файл
      rendered_template = Haml::Engine.new(haml_layout).render(self)
      File.write(HTML_FILE, rendered_template)
      return true
    end

    def haml_layout
      File.read('views/index.haml')
    end
  end
end
