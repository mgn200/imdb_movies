RSpec.describe AncientMovie do
  subject(:ancient_movie) { MovieCollection.new('movies.txt').filter(period: :ancient).sample }

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
      expect { ancient_movie.to_s }.to output("#{ancient_movie.title} - старый фильм(#{ancient_movie.year} год)").to_stdout
    end
  end
end
