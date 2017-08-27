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
    attribute :rating, Coercions::Float
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
      key.to_s.include?('exclude') ? attribute = send(key.to_s.split('_').last) : attribute = send(key)

      attr_proc = proc do
        if attribute.is_a? Array
          attribute.any? { |x| value.include? x }
        elsif attribute.is_a? String
          value.downcase == attribute.downcase
        else
          value === attribute
        end
      end

      key.to_s.include?('exclude') ? !attr_proc.call : attr_proc.call
    end

    def price
      PRICES[period]
    end

    def period
      self.class.name.match(/(\w+)Movie/)[1].to_s.downcase.to_sym
    end
  end
end
