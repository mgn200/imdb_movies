  RSpec.describe MovieProduction::Theatre do
  let(:movies) { MovieProduction::MovieCollection.new }
  let(:theatre) { MovieProduction::Theatre.new }

  describe '#take' do
    before {
      theatre.buy_ticket('Casablanca', :red)
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
      it { is_expected.to eq ["06:00".."12:00", "18:00".."24:00"] }
    end

    context 'Comedies and Adventures' do
      let(:title) { movies.filter(genre: ['Comedy', 'Adventure']).first.title }
      it { is_expected.to eq ["12:00".."18:00"] }
    end

    context 'Dramas and Horrors' do
      let(:title) { movies.filter(genre: ['Drama', 'Horror']).first.title }
      it { is_expected.to eq ["18:00".."24:00"] }
    end

    context 'Unknown title' do
      let(:title) { 'qwerty' }
      it { is_expected.to eq 'Неверное название фильма' }
    end

    context 'Unmatched movie' do
      let(:title) { 'The Terminator' }
      it { is_expected.to eq 'В данный момент этот фильм не идет в кино' }
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
      it { is_expected.to eq "Кинотеатр не работает в это время" }
    end
  end

  describe '#cash' do
    subject { theatre.cash }
    it { is_expected.to eq 0 }
  end

  describe '#buy_ticket' do
    subject { theatre.buy_ticket('Casablanca', :red) }
    it { expect(subject).to eq('Вы купили билет на Casablanca') }
    it { expect { subject }.to change(theatre, :cash).by Money.new(300) }


    describe 'puts money in cashbox' do
      let(:filter) { theatre.schedule.detect { |k, v| v[:daytime] == :morning }.last[:filters] }
      let(:title) { movies.filter(filter).first.title }

      context 'when morning time' do
        subject { theatre.buy_ticket(title, :red) }
        it { expect { subject }.to change(theatre, :cash).by Money.new(300) }
      end

      context 'when noon time' do
        let(:filter) { theatre.schedule.detect { |k, v| v[:daytime] == :afternoon }.last[:filters] }
        subject { theatre.buy_ticket(title, :green) }
        it { expect { subject }.to change(theatre, :cash).by Money.new(500) }
      end

      context 'when evening time' do
        let(:filter) { theatre.schedule.detect { |k, v| v[:daytime] == :evening }.last[:filters] }
        subject { theatre.buy_ticket(title, :blue) }
        it { expect { subject }.to change(theatre, :cash).by Money.new(1000) }
      end
    end
  end

  describe '#info' do
    let(:theatre) do
      MovieProduction::Theatre.new do
        hall :red, title: 'Красный зал', places: 100
        hall :blue, title: 'Синий зал', places: 50
        hall :green, title: 'Зелёный зал (deluxe)', places: 12

        period '09:00'..'11:00' do
          description 'Утренний сеанс'
          filters genre: 'Comedy', year: 1900..1980, title: 'City Lights'
          price 10
          hall :red, :blue
        end

        period '11:00'..'16:00' do
          description 'Спецпоказ'
          title 'The Terminator'
          price 50
          hall :green
        end

        period '16:00'..'20:00' do
          description 'Вечерний сеанс'
          filters genre: ['Action', 'Drama'], year: 2007..Time.now.year, title: 'The Intouchables'
          price 20
          hall :red, :blue
        end

        period '19:00'..'22:00' do
          description 'Вечерний сеанс для киноманов'
          filters year: 1900..1945, exclude_country: 'USA', title: 'M'
          price 30
          hall :green
        end

        session_break '22:00'..'09:00'
      end
    end

    subject { theatre.info }

    it { expect(subject).to eq "Сегодня показываем: \n" +
                               "\t09:00 City Lights(Comedy, Drama, Romance, 1931). Red, blue hall(s).\n" +
                               "\t11:00 The Terminator(Action, Sci-Fi, 1984). Green hall(s).\n" +
                               "\t12:47 The Terminator(Action, Sci-Fi, 1984). Green hall(s).\n" +
                               "\t16:00 The Intouchables(Biography, Comedy, Drama, 2011). Red, blue hall(s).\n" +
                               "\t17:52 The Intouchables(Biography, Comedy, Drama, 2011). Red, blue hall(s).\n" +
                               "\t19:00 M(Crime, Drama, Thriller, 1931). Green hall(s).\n"
       }
  end

  describe '#pick_movies' do
    subject { theatre.pick_movies({title: 'The Terminator'}, 360)}
    it { expect(subject.first.title).to eq 'The Terminator' }
    it { expect(subject.count).to eq 3 }
  end
end
