require 'pry'
RSpec.describe ClassicMovie do
  let(:classic_movie) { build(:classic_movie) }

  describe "#to_s" do
    it 'returns a string' do
      expect(classic_movie.to_s).to eq "ClassicMovie - классический фильм, режиссёр Paul Fear(ClassicMovie,AncientMovie,ClassicMovie,ClassicMovie,ClassicMovie,ClassicMovie)"
    end
  end
end
