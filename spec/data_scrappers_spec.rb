RSpec.describe MovieProduction::Scrappers::Imdb do
  let(:movie) { MovieProduction::MovieCollection.new.all.sample}

  describe '#run' do
    subject { MovieProduction::Scrappers::Imdb.run(movie) }

    context 'returns Hash with parsed imdb info' do
      it { is_expected.to be_a Hash }
      it { expect(subject[:budget]).not_to be nil }
    end
  end
end

RSpec.describe MovieProduction::Scrappers::Tmdb do
  let(:movie) { MovieProduction::MovieCollection.new.all.sample}

  describe '#run' do
    subject { MovieProduction::Scrappers::Tmdb.run(movie, :title) }
    it { is_expected.to be_a Hash }
    it { expect(subject["title"]).not_to be nil }
  end
end
