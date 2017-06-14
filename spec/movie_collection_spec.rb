RSpec.describe MovieCollection do
  mc = MovieCollection.new('movies.txt')
  mc_test = MovieCollection.new('movies_for_spec.txt')

  describe 'create 4 movie categores on initialize' do
    it 'creates ModernMovie' do
      expect(mc_test.all.first.is_a? ModernMovie).to be true
    end

    it 'creates ClassicMovie' do
      expect(mc_test.all[1].is_a? ClassicMovie).to be true
    end

    it 'creates AncientMovie' do
      expect(mc_test.all[2].is_a? AncientMovie).to be true
    end

    it 'creates NewsMovie' do
      expect(mc_test.all[3].is_a? NewMovie).to be true
    end
  end

  describe '#pick_movie' do
    it 'returns random movie from array, preferably higher rated' do
      arr = mc.filter(period: 'Ancient')
      expect((mc.pick_movie(arr)).is_a? AncientMovie).to be true
    end
  end
end
