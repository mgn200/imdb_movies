require 'pry'
RSpec.describe ModernMovie do
  let(:modern_movie) { build(:modern_movie) }

  describe "#to_s" do
    it 'returns a string' do
      expect(modern_movie.to_s).to eq "#{modern_movie.title} - старый фильм(#{modern_movie.year})"
    end
  end
end
