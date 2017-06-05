require 'pry'
RSpec.describe ClassicMovie do
  let(:classic_movie) { build(:classic_movie) }

  describe "#to_s" do
    it 'returns a string' do
      expect(classic_movie.to_s).to eq "#{classic_movie.title} - старый фильм(#{classic_movie.year})"
    end
  end
end
