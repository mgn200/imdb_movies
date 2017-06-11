RSpec.describe ClassicMovie do
  let(:classic_movie) { build(:classic_movie) }

  describe '#initialze' do
    it 'sets price' do
      expect(classic_movie.price).to eq 1.5
    end

    it 'sets period' do
      expect(classic_movie.period).to eq 'Classic'
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      expect(classic_movie.to_s).to eq "ClassicMovie - классический фильм, режиссёр Paul Fear(ClassicMovie,AncientMovie,ClassicMovie,ClassicMovie,ClassicMovie,ClassicMovie)"
    end
  end
end
