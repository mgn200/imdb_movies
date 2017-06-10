require 'pry'
RSpec.describe NewMovie do
  let(:new_movie) { build(:new_movie) }

  describe '#initialze' do
    it 'sets price' do
      expect(new_movie.price).to eq 5
    end

    it 'sets period' do
      expect(new_movie.period).to eq 'New'
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      expect(new_movie.to_s).to eq "NewMovie - новинка, вышло 13 лет назад!"
    end
  end
end
