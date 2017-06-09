require 'pry'
RSpec.describe AncientMovie do
  let(:ancient_movie) { build(:ancient_movie) }

  describe "#to_s" do
    it 'returns a string' do
      expect(ancient_movie.to_s).to eq "AncientMovie - старый фильм(1944 год)"
    end
  end
end
