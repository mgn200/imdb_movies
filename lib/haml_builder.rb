require 'haml'
require 'pry'

module MovieProduction
  # Создает html-шаблон по мувикам
  class HamlBuilder
    def initialize(movies_collection)
       # разбиваем фильмы на субмассивы по две штуки
       # один массив - один ряд фильмов d представлении(два наименования в однои ряде бутстрап сетки)
       # для каждого фильма тянем доп. инфу?(очень долго, тесты тормозят здесь, беру только 12 мувиков)
       @movies_row = movies_collection.all #.sample(4)
                                      .each_slice(2)
                                      .to_a

       @movies_row.flatten.each do |movie|
         movie.save_additional_info(MovieProduction::Scrappers::Tmdb, :title, :poster_path)
         movie.save_additional_info(MovieProduction::Scrappers::Imdb)
       end
       # Удаляем старый файл и создаем чистый при очередной записи шаблона
       File.new(html_layout, 'w+')
    end

    def build_html
      # берет мувик и по каждому атриюуту создаёт строку
      # создает готовый файл
      rendered_template = create_template(haml_layout).render(self)
      File.open(html_layout, 'a') { |file| file.write(rendered_template) }
      binding.pry
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
