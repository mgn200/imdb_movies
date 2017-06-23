RSpec.describe MovieCollection do
  let(:movie_collection) { MovieCollection.new('movies.txt') }
  let(:random_movie_arr) { movie_collection.filter(period: :ancient) }

  describe 'create 4 movie categores on initialize' do
    context 'year < 1945' do
      subject { movie_collection.filter(year: 1900...1945) }
      it { is_expected.to all be_a AncientMovie }
    end

    context 'year 1945-1968' do
      subject { movie_collection.filter(year: 1945...1968) }
      it { is_expected.to all be_a ClassicMovie }
    end

    context 'year 1968-2000' do
      subject { movie_collection.filter(year: 1968...2000) }
      it { is_expected.to all be_a ModernMovie }
    end

    context 'year > 2000 ' do
      subject { movie_collection.filter(year: 2000...2018) }
      it { is_expected.to all be_a NewMovie }
    end
  end

  describe '#pick_movie' do
    subject { movie_collection.pick_movie(random_movie_arr) }
    it { is_expected.to be_a AncientMovie }
  end
end
