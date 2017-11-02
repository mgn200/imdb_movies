RSpec.describe MovieProduction::DataScrappers::Imdb do
  describe '#run' do
    subject { MovieProduction::DataScrappers::Imdb.run }

    context 'returns ostruct of parsed strings' do
      it { is_expected.to be_a OpenStruct }
    end

    context 'use existing html file' do

    end
  end
end

RSPec.describe MovieProduction::DataScrappers::Tmdb do
  describe '#run' do
    subject { MovieProduction::DataScrappers::Tmdb.run(movie, :title) }
    it { is_expected.to be_a OpenStruct }
  end
end
