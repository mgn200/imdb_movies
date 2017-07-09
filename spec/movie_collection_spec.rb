RSpec.describe Movieproduction::MovieCollection do
  let(:movie_collection) { Movieproduction::MovieCollection.new }

  describe 'create 4 movie categores on initialize' do
    context 'year < 1945' do
      subject { movie_collection.filter(year: 1900...1945) }
      it { is_expected.to all be_a Movieproduction::AncientMovie }
    end

    context 'year 1945-1968' do
      subject { movie_collection.filter(year: 1945...1968) }
      it { is_expected.to all be_a Movieproduction::ClassicMovie }
    end

    context 'year 1968-2000' do
      subject { movie_collection.filter(year: 1968...2000) }
      it { is_expected.to all be_a Movieproduction::ModernMovie }
    end

    context 'year > 2000 ' do
      subject { movie_collection.filter(year: 2000...2018) }
      it { is_expected.to all be_a Movieproduction::NewMovie }
    end
  end

  describe 'has Enumerable methods' do
    context 'select' do
      subject { movie_collection.select {|x| (1968...2000) === x.year }.first }
      it { is_expected.to be_a Movieproduction::ModernMovie }
    end

    context 'map' do
      subject { movie_collection.map(&:genre) }
      it { is_expected.to be_a Array }
    end
  end
end
