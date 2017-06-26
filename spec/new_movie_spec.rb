RSpec.describe NewMovie do
  list = nil
  movie_info = { title: 'Test movie',
                 year: 2002,
                 actors: 'A, B, C',
                 genre: 'Comedy',
                 date: '2002-04-03'
               }

  subject(:new_movie) { NewMovie.new(list, movie_info) }

  describe '#initialze' do
    context 'price' do
      it { is_expected.to have_attributes(price: 5) }
    end

    context 'period' do
      it { is_expected.to have_attributes(period: :new) }
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      years_passed = Date.today.year - new_movie.year
      expect(new_movie.to_s).to eq "#{new_movie.title} - новинка, вышло #{years_passed} лет назад!"
    end
  end
end
