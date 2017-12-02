# rubocop:disable Namin/PredicateName
module ImdbPlayfield
  # Class that parses movie.txt file, creates Movies with attributes and saves it in variable
  # Contains different filtering options to work with movie collection
  # @see Movie
  class MovieCollection
    # Enumerable methods will by default use @all as data
    include Enumerable
    # KEYS serve as attributes for parsed Movies
    KEYS = %w[link title year country date genre duration rating director actors].freeze
    attr_reader :all

    # Initializes an array of different movies from given file
    # @param file [String] path to the movies file
    # @return [Array<AncientMovie, ModernMovie, NewMovie, ClassicMovie>] of parsed movies stored in @all
    def initialize(file = File.join(File.dirname(File.expand_path("../../", __FILE__)), 'data/movies.txt'))
      @filename = file
      abort('No movie file') unless File.exist? file
      @all = parse_file(file)
    end

    # Sorts movie collection by given attribute
    # @param field [Symbol] any of the KEYS(movie attributes)
    # @return [String] sorted movies
    def sort_by(attribute)
      if attribute == :director
        puts (sort_by { |x| x.director.split(' ').last })
      else
        puts (sort_by { |x| x.send attribute }.map(&:to_s))
      end
    end

    # Filters movie collection by given params
    # @param [Hash, Array] [hash, array] hash of filters and an array that needs filtering
    # @return [Array] filtered array of movies
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

    # Check of genre exist in current movie collection
    # @param genre [String] genre string, like 'Comedy' or 'Drama'
    # @return [Boolean] true if genre exist
    def has_genre?(genre)
      map(&:genre).flatten.uniq.include? genre
    end

    # Random pick that weights movie rating. Higher rated movies are more likely to be picked
    # @param movie_array [Array] array if movies that respond to #rating
    # @return [<AncientMovie, ModernMovie, NewMovie, ClassicMovie>] picked movie
    def pick_movie(movies_array)
      movies_array.sort_by { |x| x.rating.to_f * rand(1..1.5) }.last
    end

    private

    # Parses movie file, crates movie objects based on movie year production
    # @param file [String] path to file that can be parsed
    # @return [Array<AncientMovie, ModernMovie, NewMovie, ClassicMovie>] array of movies
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
