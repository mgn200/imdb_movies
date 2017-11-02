# rubocop:disable Style/CaseEquality
# rubocop:disable Namin/PredicateName
require 'pry'

module MovieProduction
  class Movie
    include Virtus.model
    PRICES = { ancient: Money.new(100, 'USD'),
               classic: Money.new(150, 'USD'),
               modern: Money.new(300, 'USD'),
               new: Money.new(500, 'USD') }.freeze

    # set to reader only
    attribute :list
    attribute :movie_info
    attribute :duration, Coercions::Integer
    attribute :actors, Coercions::Splitter
    attribute :genre, Coercions::Splitter
    attribute :date, Coercions::DateParse
    attribute :rating, Float
    attribute :director
    attribute :title
    attribute :price
    attribute :year, Coercions::Integer
    attribute :link
    attribute :country
    attribute :additional_info, Hash

    def to_s
      "#{@title}, #{@detailed_year}, #{@director}, #{@rating}"
    end

    def month
      Date::MONTHNAMES[@date.mon] unless @date.nil?
    end

    def has_genre?(genre_name)
      raise ArgumentError, 'Invalid genre name' unless @list.has_genre? genre_name
      @genre.any? { |x| genre_name.include? x }
    end

    def matches?(key, value)
      attribute = key.to_s.include?('exclude') ? send(key.to_s.split('_').last) : send(key)

      result = if attribute.is_a? Array
                 attribute.any? { |x| value.include? x }
               elsif attribute.is_a? String
                 value.downcase == attribute.downcase
               else
                 value === attribute
               end

      key.to_s.include?('exclude') ? !result : result
    end

    def price
      PRICES[period]
    end

    def period
      self.class.name.match(/(\w+)Movie/)[1].to_s.downcase.to_sym
    end

    def imdb_id
      self.link.split("|").first.split("/")[4]
    end

    # запрос к объекту, который возвращает хэш нужной доп. инфы - чья функция лезть в YML файл с инфой
    def save_additional_info(scrapper, *keys)
      self.additional_info.merge! scrapper.run(self, keys)
      #binding.pry
      # достает для каждого мувика доп. инфу для отображения в index.html
      #imdb_id = get_imdb_id
      #data = YAML.load_file(yml_file)
      # Создать служебный объект для работы c YML и предоставлением данных Movie?
      #options = data.find { |data_hash| data_hash.has_key? imdb_id }[imdb_id]
      #self.additional_info = options
    end
  end
end
