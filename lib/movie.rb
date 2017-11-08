# rubocop:disable Style/CaseEquality
# rubocop:disable Namin/PredicateName
require 'pry'
require 'money'

module MovieProduction
  class Movie
    include Virtus.model
    TMDB_YML_FILE = File.expand_path("lib/tmdb_data/movies_tmdb_info.yml")
    IMDB_YML_FILE = File.expand_path("lib/imdb_data/movies_imdb_info.yml")
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

    def poster
      tmdb_info['poster_path']
    end

    def rus_title
      tmdb_info['title']
    end

    def budget
      imdb_info[:budget]
    end

    def tmdb_info
      @tmdb_info ||= File.exist?(TMDB_YML_FILE) ? YAML.load_file(TMDB_YML_FILE)[imdb_id] : {}
    end

    def imdb_info
      @imdb_info ||= File.exist?(IMDB_YML_FILE) ? YAML.load_file(IMDB_YML_FILE)[imdb_id] : {}
    end
  end
end
