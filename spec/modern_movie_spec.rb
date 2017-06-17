RSpec.describe ModernMovie do
  subject(:modern_movie) { MovieCollection.new('movies.txt').filter(period: 'Modern').sample }

  describe '#initialze' do
    context 'price' do
      it { is_expected.to have_attributes(price: 3) }
    end

    context 'period' do
      it { is_expected.to have_attributes(period: 'Modern') }
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      actors = modern_movie.actors.join(",")
      expect(modern_movie.to_s).to eq "#{modern_movie.title} - современное кино: играют #{actors}."
    end
  end
end
