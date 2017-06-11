RSpec.describe ModernMovie do
  let(:modern_movie) { build(:modern_movie) }

  describe '#initialze' do
    it 'sets price' do
      expect(modern_movie.price).to eq 3
    end

    it 'sets period' do
      expect(modern_movie.period).to eq 'Modern'
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      expect(modern_movie.to_s).to eq "ModernMovie - современное кино: играют Bob, Jack."
    end
  end
end
