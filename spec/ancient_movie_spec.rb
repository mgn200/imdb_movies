RSpec.describe AncientMovie do
  subject(:ancient_movie) { MovieCollection.new('movies.txt').filter(period: 'Ancient').sample }

  describe '#initialze' do
    context 'price' do
      it { is_expected.to have_attributes(price: 1) }
    end

    context 'period' do
      it { is_expected.to have_attributes(period: 'Ancient') }
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      expect(ancient_movie.to_s).to eq "#{ancient_movie.title} - старый фильм(#{ancient_movie.year} год)"
    end
  end
end
