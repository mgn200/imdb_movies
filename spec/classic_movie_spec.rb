RSpec.describe ClassicMovie do
  subject(:classic_movie) { MovieCollection.new('movies.txt').filter(period: :classic).sample }

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
