RSpec.describe ImdbPlayfield::NetflixDSL do
  describe 'Netflix methods' do
    let(:netflix) { ImdbPlayfield::Netflix.new }
    context '#by_genre' do
      subject { netflix.by_genre.comedy.sample.genre }
      it { expect(subject.include? 'Comedy').to be true }
    end

    context '#by_contry' do
      subject { netflix.by_country.usa.sample.country }
      it { is_expected.to eq 'USA'}
    end
  end
end
