# Объект, который обращается в YML файлу и достает из него дополнительную
# информацию по фильму... может просто добавить это как метод в Movies?
require 'ostruct'

module MovieProduction
  class AdditionalMovieInfo
    def self.fetch_data(movie, keys = [])
      raise ArgumentError, 'Укажите, какие доп. параметры нужно получить.' if keys.empty?
      keys.map!(&:to_s)
      data = YAML.load_file(TMDBApi::YML_FILE_PATH)
      raise StandartError, 'В файле нет данных. Запустите скрипт, чтобы собрать информацию.' if data.empty?
      attributes = data.find { |hash| hash.has_key? movie.imdb_id }[movie.imdb_id]
                                  .select { |k, | keys.include? k }
      OpenStruct.new(attributes)
    end
  end
end
