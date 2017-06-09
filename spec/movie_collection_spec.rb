RSpec.describe MovieCollection do
  #let(:movie_collection) { build :movie_collection }
  mc = MovieCollection.new('movies_for_spec.txt')

  describe 'create 4 movie categores on initialize' do
    it 'creates ModernMovie' do
      expect(mc.all.first.is_a? ModernMovie).to be true
    end

    it 'creates NewMovie' do
      expect(mc.all[1].is_a? ClassicMovie).to be true
    end

    it 'creates ClassicMovie' do
      expect(mc.all[2].is_a? AncientMovie).to be true
    end

    it 'creates AncientMovie' do
      expect(mc.all[3].is_a? NewMovie).to be true
    end
  end

  describe '#to_s' do
    context 'AncientMovie' do

    end
  end
end
