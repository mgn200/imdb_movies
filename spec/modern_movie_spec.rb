RSpec.describe ModernMovie do
  subject(:modern_movie) { MovieCollection.new('movies.txt').filter(period: :modern).sample }

  describe '#initialze' do
    context 'price' do
      it { is_expected.to have_attributes(price: 3) }
    end

    context 'period' do
      it { is_expected.to have_attributes(period: :modern) }
    end
  end

  describe "#to_s" do
    it 'returns a string' do
      actors = modern_movie.actors.join(",")
      expect { modern_movie.to_s }.to output("#{modern_movie.title} - современное кино: играют #{actors}.").to_stdout
    end
  end
end
