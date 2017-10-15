require 'haml'
module MovieProduction
  # Создает html-шаблон по мувикам из класса
  class HamlBuilder
    attr_reader :movies

    def initialize(movies_collection)
      # разбиваем фильмы на субмассивы по две штуки
      # один массив - один ряд фильмов из двух наименований
      @movies_row = movies_collection.all
                                     .sample(12)
                                     .each_slice(2)
                                     .to_a
      # Удаляем старый файл и создаем чистый
      File.new(html_layout, 'w+')
    end

    def build_html
      # берет мувик и по каждому атриюуту создаёт строку
      # создает готовый файл
      rendered_template = create_template(haml_layout).render(self)
      File.open(html_layout, 'a') { |line| line.write(rendered_template) }
      "Index file created"
    end

    def create_template(template)
      Haml::Engine.new(template)
    end

    def html_layout
      "views/index.html"
    end

    def haml_layout
      File.read('views/index.haml')
    end
  end
end
