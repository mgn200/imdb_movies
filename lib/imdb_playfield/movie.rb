# rubocop:disable Style/CaseEquality
# rubocop:disable Naming/PredicateName
module ImdbPlayfield
  # @abstract
  # Holds data on specific movie. Grants access to additional movie information provided
  # by TMDB.com and IMDB.com
  # Do not create objects of this class, they are created by {MovieCollection}.
  class Movie
    # Gem that simplifies object attributes.
    include Virtus.model

    # Prices based on movie type
    PRICES = { ancient: Money.new(100, 'USD'),
               classic: Money.new(150, 'USD'),
               modern: Money.new(300, 'USD'),
               new: Money.new(500, 'USD') }.freeze

    # Keys created from MovieCollection and movies file
    # @see MovieCollection#parse_file
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

    # Basic method, overriden in child objects.
    # @return [String] when title, detailed year, director and rating info
    def to_s
      "#{@title}, #{@detailed_year}, #{@director}, #{@rating}"
    end

    # @return [String] month name from movie creation date
    def month
      Date::MONTHNAMES[@date.mon] unless @date.nil?
    end

    # Check if genre exist in movie collection.
    # @note
    #   Movie collection is sotred in @list, it is passed on creation.
    # @see MovieCollection#parse_file
    # @see MovieCollection#has_genre?
    def has_genre?(genre_name)
      raise ArgumentError, 'Invalid genre name' unless @list.has_genre? genre_name
      @genre.any? { |x| genre_name.include? x }
    end

    # Checks if current movie matches given parameters.
    # Key and value arguments are movie attribute and it's value.
    # @param key [Symbol] movie attribute that is being compared
    # @param value [Object] value of movie attribute, comparison is different based on value type.
    # @return [Boolean] true if movie matches given parameters
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

    # Returns Hash containing information from TMDB.com
    # @see TMDBApi
    # @return [Hash] of different data from TMDB.com
    def tmdb_info
      @tmdb_info ||= YAML.load_file(ImdbPlayfield::TMDBApi.tmdb_yml_file)[imdb_id]
    end

    # Returns Hash containing information from imdb.com
    # @see IMDBscrapper
    # @return [Hash] of different data from imdb.com
    def imdb_info
      @imdb_info ||= YAML.load_file(ImdbPlayfield::IMDBScrapper.imdb_yml_file)[imdb_id]
    end
  end
end
