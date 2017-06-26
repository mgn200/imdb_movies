RSpec.describe ModernMovie do
  list = nil
  movie_info = { title: 'Test movie',
                 year: 1984,
                 actors: 'A, B, C',
                 genre: 'Comedy',
                 date: '1984-04-03'
               }

  subject(:modern_movie) { ModernMovie.new(list, movie_info) }

  describe '#initialze' do
    context 'price' do
      it { is_expected.to have_attributes(price: 3) }
    end

    context 'period' do
      it { is_expected.to have_attributes(period: :modern) }
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      actors = modern_movie.actors.join(",")
      expect(modern_movie.to_s).to eq "#{modern_movie.title} - современное кино: играют #{actors}."
    end
  end
end
