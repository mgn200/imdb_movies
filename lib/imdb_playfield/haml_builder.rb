
module ImdbPlayfield
  # Создает html-шаблон по мувикам
  class HamlBuilder
    def initialize(movies_array = ImdbPlayfield::MovieCollection.new)
       # разбиваем фильмы на субмассивы по две штуки
       # один массив - один ряд фильмов d представлении(два наименования в однои ряде бутстрап сетки)
       # для каждого фильма тянем доп. инфу?(тесты тормозят здесь, если вкидывать все 250 фильмов)
       @bootstrap_js = File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/views/js/bootstrap.min.js')
       @bootstrap_css = File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/views/css/bootstrap.min.css')
       @movies_row = movies_array.each_slice(2).to_a
    end

    def build_html
      # берет мувик и по каждому атриюуту создаёт строку
      # создает готовый  html файл
      rendered_template = Haml::Engine.new(haml_layout).render(self)
      File.write(html_file, rendered_template)
      return true
    end

    def haml_layout
      file = File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/views/index.haml')
      File.read file
    end

    def html_file
      File.expand_path("data/views/index.html")
    end
  end
end
