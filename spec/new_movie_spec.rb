RSpec.describe NewMovie do
  subject(:new_movie) { MovieCollection.new('movies.txt').filter(period: :new).sample }

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
