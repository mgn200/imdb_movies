RSpec.describe Theatre do
  let(:movies) { MovieCollection.new('movies.txt') }
  let(:theatre) { Theatre.new }

  describe '#when?' do
    subject { theatre.when? title }
    context 'Ancient Movies' do
      let(:title) { movies.filter(period: :ancient).first.title }
      it { is_expected.to eq "06:00".."12:00" }
    end

    context 'Comedies and Adventures' do
      let(:title) { movies.filter(genre: ['Comedy', 'Adventure']).first.title }
      it { is_expected.to eq "12:00".."18:00" }
    end

    context 'Dramas and Horrors' do
      let(:title) { movies.filter(genre: ['Drama', 'Horror']).first.title }
      it { is_expected.to eq "18:00".."24:00" }
    end

    context 'Unknown title' do
      let(:title) { 'qwerty' }
      it { is_expected.to eq 'No such movie' }
    end
  end

  describe '#show' do
    context '06:00 - 12:00' do
      subject { theatre.show('07:22') }
      it { is_expected.to include 'will be shown at 07:22' }
    end

    context '12:00 - 18:00' do
      subject { theatre.show('12:22') }
      it { is_expected.to include 'will be shown at 12:22' }
    end

    context '18:00 - 24:00' do
      subject { theatre.show('19:22') }
      it { is_expected.to include 'will be shown at 19:22' }
    end

    context '00:00 - 06:00' do
      subject { theatre.show('00:22') }
      it { is_expected.to eq "Working hours: 06:00 - 00:00" }
    end
  end
end
