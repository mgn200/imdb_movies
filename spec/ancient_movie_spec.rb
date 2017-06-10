require 'pry'
RSpec.describe AncientMovie do
  let(:ancient_movie) { build(:ancient_movie) }

  describe '#initialze' do
    it 'sets price' do
      expect(ancient_movie.price).to eq 1
    end

    it 'sets period' do
      expect(ancient_movie.period).to eq 'Ancient'
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      expect(ancient_movie.to_s).to eq "AncientMovie - старый фильм(1944 год)"
    end
  end
end
