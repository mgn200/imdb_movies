RSpec.describe Movieproduction::Theatre do
  let(:movies) { Movieproduction::MovieCollection.new }
  let(:theatre) { Movieproduction::Theatre.new }

  describe '#take' do
    before {
      theatre.buy_ticket 'Casablanca'
    }

    context "when 'Bank' params" do
      subject { theatre.take "Bank" }
      it { expect(subject).to eq 'Проведена инкассация'  }
      it { expect { subject }.to change(theatre, :cash).to 0 }
    end

    context "other params" do
      subject { theatre.take "Another" }
      it { expect { subject }.to raise_error(ArgumentError, 'Вызываю полицию') }
    end
  end

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

    context 'Unmatched movie' do
      let(:title) { 'The Terminator' }
      it { is_expected.to eq 'That movie is not at the box office atm' }
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

  describe '#cash' do
    subject { theatre.cash }
    it { is_expected.to eq 0 }
  end

  describe '#buy_ticket' do
    subject { theatre.buy_ticket 'Casablanca' }
    it { expect(subject).to eq('Вы купили билет на Casablanca') }
    it { expect { subject }.to change(theatre, :cash).by Money.new(300) }


    describe 'puts money in cashbox' do
      let(:filter) { Movieproduction::Theatre::SCHEDULE.values[0] }
      let(:title) { movies.filter(filter).first.title }
      subject { theatre.buy_ticket(title) }

      context 'when morning time' do
        it { expect { subject }.to change(theatre, :cash).by Money.new(300) }
      end

      context 'when noon time' do
        let(:filter) { Movieproduction::Theatre::SCHEDULE.values[1] }
        it { expect { subject }.to change(theatre, :cash).by Money.new(500) }
      end

      context 'when evening time' do
        let(:filter) { Movieproduction::Theatre::SCHEDULE.values[2] }
        it { expect { subject }.to change(theatre, :cash).by Money.new(1000) }
      end
    end
  end
end
