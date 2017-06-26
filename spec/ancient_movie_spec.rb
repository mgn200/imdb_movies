RSpec.describe AncientMovie do
  list = nil
  movie_info = { title: 'Test movie',
                 year: 1944,
                 actors: 'A, B, C',
                 genre: 'Comedy',
                 date: '1944-04-03'
               }
  subject(:ancient_movie) { AncientMovie.new(list, movie_info) }

  describe '#initialze' do
    context 'price' do
      it { is_expected.to have_attributes(price: 1) }
    end

    context 'period' do
      it { is_expected.to have_attributes(period: :ancient) }
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      expect(ancient_movie.to_s).to eq "#{ancient_movie.title} - старый фильм(#{ancient_movie.year} год)"
    end
  end
end
