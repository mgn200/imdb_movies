# скрипт, обрабатывающий YML файл из запроса к TMDB API.
# достаем строго прописанные ключи(?) тайтл на русском и постер
require 'yaml'
# сделать просто методом мувика?
class TmdbYmlParser
  def self.run(movies)
    #raise ArgumentError, 'Укажите, какие доп. параметры нужно получить.' if keys.empty?
    #keys.map!(&:to_s)
    #
    data = YAML.load_file(TMDBApi::YML_FILE_PATH)
    binding.pry

    raise StandartError, 'В файле нет данных. Запустите скрипт TMDBApi, чтобы собрать информацию.' if data.empty?
    attributes = data.find { |hash| hash.has_key? movie.imdb_id }[movie.imdb_id]
                     .select { |k, | keys.include? k }
  end
end
