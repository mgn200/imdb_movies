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
    attribute :duration, MovieProduction::Coercions::Integer
    attribute :actors, MovieProduction::Coercions::Splitter
    attribute :genre, MovieProduction::Coercions::Splitter
    attribute :date, MovieProduction::Coercions::DateParse
    attribute :rating
    attribute :director
    attribute :title
    attribute :price
    attribute :year, MovieProduction::Coercions::Integer
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
      func = send(key)
      if func.is_a? Array
        func.any? { |x| value.include? x }
      else
        value === func
      end
    end

    def price
      PRICES[period]
    end

    def period
      self.class.name.match(/(\w+)Movie/)[1].to_s.downcase.to_sym
    end
  end
end
