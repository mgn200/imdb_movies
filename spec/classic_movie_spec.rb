RSpec.describe ClassicMovie do
  list = MovieCollection.new
  movie_info = { title: 'Test movie',
                 year: 1954,
                 actors: 'A, B, C',
                 genre: 'Comedy',
                 date: '1954-04-03'
               }

  subject(:classic_movie) { ClassicMovie.new(list, movie_info) }

  describe '#initialze' do
    context 'price' do
      it { is_expected.to have_attributes(price: 1.5) }
    end

    context 'period' do
      it { is_expected.to have_attributes(period: :classic) }
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      director_movies = classic_movie.list
                            .filter(director: classic_movie.director)
                            .map(&:title).join(",")
      expect(classic_movie.to_s).to eq "#{classic_movie.title} - классический фильм, режиссёр #{classic_movie.director}(#{director_movies})"
    end
  end
end
