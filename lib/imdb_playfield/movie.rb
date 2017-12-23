# rubocop:disable Style/CaseEquality
# rubocop:disable Namin/PredicateName
module ImdbPlayfield
  # @abstract
  #  Provides interface for children movie objects(Ancient,Modern,Classic,New)
  class Movie
    # Simplified object attributes
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

    # Absolute path to movies_tmdb_info.yml
    # @note
    #  If user ran IMDBScrapper or TMDBApi to get external movie info, then new yml file and folder were created in users folder.
    #  Method will return that path instead of one stored in local gem folder.
    # @return [String] absolute path to tmdb_movie_info.yml
    # @see TMDBApi::USER_FILE
    def tmdb_yml_file
      return File.expand_path(ImdbPlayfield::TMDBApi::USER_FILE) if File.exist?(ImdbPlayfield::TMDBApi::USER_FILE)
      ImdbPlayfield::TMDBApi::GEM_YML_FILE
    end

    # Absolute path to movies_imdb_info.yml.
    # @return [String] absolute path to imdb_movie_info.yml
    # @note
    #  If user ran IMDBScrapper or TMDBApi to get external movie info, then new yml file and folder were created in users folder.
    #  Method will return that path instead of one stored in local gem folder.
    # @see Movie#tmdb_yml_file
    # @see IMDBScrapper::USER_FILE
    def imdb_yml_file
      return File.expand_path(ImdbPlayfield::IMDBScrapper::USER_FILE) if File.exist?(ImdbPlayfield::IMDBScrapper::USER_FILE)
      ImdbPlayfield::IMDBScrapper::GEM_YML_FILE
    end

    # Basic method, overriden in child objects.
    # @return [String] when title, detailed year, director and rating info
    def to_s
      "#{@title}, #{@detailed_year}, #{@director}, #{@rating}"
    end

    # @return [String] name of the month
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

    # Checks if movie matches given parameters.
    # @note
    #   Key and value are movie attribute and it's value.
    #   You can also use exclude_#{key} to specify what value you don't want to see in the movie.
    # @param key [Symbol] movie attribute
    # @param value [Numeric, Date, String] value of attribute
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
      @tmdb_info ||= YAML.load_file(tmdb_yml_file)[imdb_id]
    end

    # Returns Hash containing information from imdb.com
    # @see IMDBscrapper
    # @return [Hash] of different data from imdb.com
    def imdb_info
      @imdb_info ||= YAML.load_file(imdb_yml_file)[imdb_id]
    end
  end
end
