require 'pry'
RSpec.describe NewMovie do
  let(:new_movie) { build(:new_movie) }

  describe "#to_s" do
    it 'returns a string' do
      expect(new_movie.to_s).to eq "NewMovie - новинка, вышло 13 лет назад!"
    end
  end
end
