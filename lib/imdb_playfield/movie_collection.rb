# rubocop:disable Namin/PredicateName
module ImdbPlayfield
  # Class that parses movie.txt file, creates Movies with attributes and saves it in variable.
  # Contains different filtering options to work with movie collection.
  # List of movies.
  # Allow different filtering and sorting of list. Creates that list from
  # movies.txt(default file), or similar file provided by user.
  # @see Movie
  class MovieCollection
    # Enumerable methods will by default use @all as data.
    include Enumerable
    # KEYS serve as attributes for parsed Movies.
    KEYS = %w[link title year country date genre duration rating director actors].freeze
    attr_reader :all

    # Loads movie collection from file.
    # @param file [String] path to the movies file
    # @return [Array<AncientMovie, ModernMovie, NewMovie, ClassicMovie>] of parsed movies stored in @all
    def initialize(file = File.expand_path('../../../data/movies.txt', __FILE__))
      @filename = file
      abort('No movie file') unless File.exist? file
      @all = parse_file(file)
    end

    # Sorts movie collection by given attribute.
    # @param attribute [Symbol] any of the KEYS(movie attributes)
    # @return [String] sorted movies
    def sort_by(attribute)
      if attribute == :director
        puts (sort_by { |x| x.director.split(' ').last })
      else
        puts (sort_by { |x| x.send attribute }.map(&:to_s))
      end
    end

    # Filters movie collection with given parameters.
    # Parameters are movie attributes stored in hash.
    # You can also use exclude_(movie_attribute) parameter for more specific filtering.
    # @example
    #   mc = ImdbPlayfield::MovieCollection.new
    #   mc.filter { year: 1990, genre: 'Comedy', exclude_country: 'USA' }
    # @param hash [Hash] hash of movie attributes and their values
    # @param array [Array] optional parameter. Array that will be filtered, default is MovieCollection.all. It is used in child object method{Netflix#filter} - filtered array is sent here for final filtering.
    # @return [Array<Movie>] filtered array of movies
    def filter(hash, array = nil)
      array ||= all
      hash.reduce(array) do |sequence, (k, v)|
        sequence.select { |x| x.matches?(k, v) }
      end
    end

    # Counts every value of given attribute in movie collection.
    # @param attribute [Symbol] any of the KEYS(movie attributes)
    # @return [Hash] attribute values and number of its occurances
    def stats(attribute)
      flat_map(&attribute).group_by(&:itself).map { |val, group| [val, group.count] }.to_h
    end

    # Check if genre exist in current movie collection.
    # @param genre [String] genre string, like 'Comedy' or 'Drama'
    # @return [Boolean] true if genre exist
    def has_genre?(genre)
      map(&:genre).flatten.uniq.include? genre
    end

    # Random pick that weighs movie rating. Higher rated movies are more likely to be picked
    # @param movies_array [Array] array of movies that respond to #rating
    # @return [<AncientMovie, ModernMovie, NewMovie, ClassicMovie>] picked movie
    def pick_movie(movies_array)
      movies_array.sort_by { |x| x.rating.to_f * rand(1..1.5) }.last
    end

    private

    def parse_file(file)
      CSV.foreach(file, col_sep: '|', headers: KEYS).map do |row|
        year = row['year'].to_i
        case year
        when (1900..1945)
          AncientMovie.new(row.to_h.merge(list: self))
        when (1946..1967)
          ClassicMovie.new(row.to_h.merge(list: self))
        when (1968..1999)
          ModernMovie.new(row.to_h.merge(list: self))
        when (2000..3000)
          NewMovie.new(row.to_h.merge(list: self))
        end
      end
    end

    # Needed for Enumerable module to work properly
    def each(&block)
      @all.each(&block)
    end
  end
end
