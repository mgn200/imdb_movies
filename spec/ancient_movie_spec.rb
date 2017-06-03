require 'pry'
RSpec.describe AncientMovie do
  let(:ancient_movie) { AncientMovie.new( {title: 'Test title', year: 1949 }) }

  describe "#to_s" do
    it 'returns a string' do
      expect(ancient_movie.to_s).to eq "#{ancient_movie.title} - старый фильм(#{ancient_movie.year})"
    end
  end
end
