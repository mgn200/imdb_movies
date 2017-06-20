RSpec.describe Theatre do
  movies = MovieCollection.new('movies.txt')
  let(:theatre) { Theatre.new(movies) }

  describe '#when?' do
    context 'Ancient Movies' do
      title = movies.filter(period: 'Ancient').first.title
      it { expect(theatre.when? title).to eq "06:00".."12:00" }
    end

    context 'Comedies and Adventures' do
      title = movies.filter(genre: ['Comedy', 'Adventure']).first.title
      it { expect(theatre.when? title).to eq "12:00".."18:00" }
    end

    context 'Dramas and Horrors' do
      title = movies.filter(genre: ['Drama', 'Horror']).first.title
      it { expect(theatre.when? title).to eq "18:00".."24:00" }
    end

    context 'Unknown title' do
      title = 'qwerty'
      it { expect(theatre.when? title).to eq "No such movie" }
    end
  end

  describe '#show' do
    context '06:00 - 12:00' do
      subject { theatre.show('07:22') }
      it { is_expected.to be_a String }
    end

    context '12:00 - 18:00' do
      subject { theatre.show('12:22') }
      it { is_expected.to be_a String }
    end

    context '18:00 - 24:00' do
      subject { theatre.show('12:22') }
      it { is_expected.to be_a String }
    end

    context '00:00 - 06:00' do
      subject { theatre.show('00:22') }
      it { is_expected.to be_a String }
    end
  end

  describe '#when?' do
    context 'horros and dramas' do
      it { expect(theatre.when?('Fight Club')).to eq ('18:00'..'24:00') }
    end

    context 'comedy and dventures' do
      it { expect(theatre.when?('3 Idiots')).to eq ('12:00'..'18:00') }
    end

    context'ancient movies' do
      it { expect(theatre.when?("City Lights")).to eq ('06:00'..'12:00') }
    end

    context 'invalid params' do
      it { expect(theatre.when?('TestMovie')).to eq 'No such movie' }
    end
  end
end
