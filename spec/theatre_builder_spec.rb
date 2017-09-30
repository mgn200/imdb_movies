RSpec.describe MovieProduction::Theatre do
  let(:theatre) do
    MovieProduction::Theatre.new do
      hall :red, title: 'Красный зал', places: 100
      hall :blue, title: 'Синий зал', places: 50
      hall :green, title: 'Зелёный зал (deluxe)', places: 12

      period '09:00'..'11:00' do
        description 'Утренний сеанс'
        filters genre: 'Comedy', year: 1900..1980
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
        filters genre: ['Action', 'Drama'], year: 2007..Time.now.year
        price 20
        hall :red, :blue
      end

      period '19:00'..'22:00' do
        description 'Вечерний сеанс для киноманов'
        filters year: 1900..1945, exclude_country: 'USA'
        price 30
        hall :green
      end

      session_break '22:00'..'09:00'
    end
  end

  describe 'creates schedule with given block params' do
    it { expect(theatre.schedule.keys).to eq [("09:00".."11:00"),
                                              ("11:00".."16:00"),
                                              ("16:00".."20:00"),
                                              ("19:00".."22:00"),
                                              ("22:00".."09:00")] }
    it { expect(theatre.schedule["09:00".."11:00"].attributes).to eq ({ :filters => { :genre => "Comedy", :year => 1900..1980 },
                                                                        :daytime => nil,
                                                                        :range_time => 32400..39600,
                                                                        :price => 10,
                                                                        :hall => [:red, :blue],
                                                                        :description => "Утренний сеанс",
                                                                        :session_break => false }) }

    it { expect(theatre.schedule["11:00".."16:00"].attributes).to eq ({ :filters => { :title => "The Terminator" },
                                                                        :daytime => nil,
                                                                        :range_time => 39600..57600,
                                                                        :price => 50,
                                                                        :hall => [:green],
                                                                        :description => "Спецпоказ",
                                                                        :session_break => false }) }

    it { expect(theatre.schedule["16:00".."20:00"].attributes).to eq ({ filters: { genre: ['Action', 'Drama'], year: 2007..Time.now.year },
                                                                        :daytime => nil,
                                                                        :range_time => 57600..72000,
                                                                        :price => 20,
                                                                        :hall => [:red, :blue],
                                                                        :description => "Вечерний сеанс",
                                                                        :session_break => false }) }

    it { expect(theatre.schedule["19:00".."22:00"].attributes).to eq ({ filters: { year: 1900..1945, exclude_country: 'USA' },
                                                                       :daytime => nil,
                                                                       :range_time => 68400..79200,
                                                                       :price => 30,
                                                                       :hall => [:green],
                                                                       :description => "Вечерний сеанс для киноманов",
                                                                       :session_break => false }) }
    it { expect(theatre.schedule["22:00".."09:00"].attributes).to eq ({ :session_break => true,
                                                                        :daytime => nil,
                                                                        :range_time => 79200..32400,
                                                                        :price => nil,
                                                                        :hall => nil,
                                                                        :description => nil,
                                                                        :filters => nil }) }

    context 'title params given explicitly is wrapped in params' do
      it { expect(theatre.schedule[("11:00".."16:00")][:filters]).to eq Hash[:title, 'The Terminator'] }
    end

    context 'when periods intersect by time and halls' do
      subject { MovieProduction::Theatre.new do
                  period "09:00".."11:00" do
                    hall :red
                  end

                  period "10:00".."12:00" do
                    hall :red
                  end
                end
              }

      it { expect { subject }.to raise_error(ArgumentError, 'Periods and halls intersection detected. Please check parameters.') }
    end
  end

  describe 'methods' do
    describe '#session_break' do
      context 'checks period for holes' do
        subject { MovieProduction::Theatre.new do
                          period "09:00".."13:00" do
                            hall :red
                          end

                          session_break "14:00".."18:00"
                        end
                      }
        it { expect { subject }.to raise_error(ArgumentError, 'В расписании есть неучтенное время: 13:00..14:00') }
      end
    end

    describe '#buy_ticket' do
      let(:theatre) do
        MovieProduction::Theatre.new do
          hall :red, title: 'Красный зал', places: 100
          hall :blue, title: 'Синий зал', places: 50
          hall :green, title: 'Зелёный зал (deluxe)', places: 12

          period '09:00'..'11:00' do
            description 'Утренний сеанс'
            filters genre: 'Comedy', year: 1900..1980
            price 10
            hall :red, :blue
          end

          period '11:00'..'12:00' do
            description 'Утренний сеанс'
            filters genre: 'Comedy', year: 1900..1980
            price 10
            hall :green
          end

          session_break '12:00'..'09:00'
        end
      end

      context 'when periods intersect by time' do
        subject { theatre.buy_ticket('The Apartment') }
        it { expect { subject }.to raise_error(ArgumentError, 'Выберите нужный вам зал: red | blue | green') }

        context 'when hall params is provided' do
          subject { theatre.buy_ticket('The Apartment', :green) }
          it { expect(subject).to eq('Вы купили билет на The Apartment') }
          it { expect { subject }.to change(theatre, :cash).by Money.new(1000) }
        end

        context 'when wrong hall is provided' do
          subject { theatre.buy_ticket('The Apartment', :grey) }
          it { expect { subject }.to raise_error(ArgumentError, 'Выбран неверный зал. Фильм показывают в зале: red | blue | green') }
        end
      end
    end

    describe '#when with exclude_*attr params' do
      # Metropolis checks for 19-22 period
      subject { theatre.when?('Metropolis') }
      it { is_expected.to eq ["19:00".."22:00"] }
    end

    describe '#show with exclude_*attr params' do
      let(:theatre) do
        MovieProduction::Theatre.new do
          hall :red, title: 'Красный зал', places: 100
          hall :blue, title: 'Синий зал', places: 50
          hall :green, title: 'Зелёный зал (deluxe)', places: 12

          period '06:00'..'23:00' do
            description 'Утренний сеанс'
            filters exclude_year: 1900..1998,
                    exclude_genre: 'Fantasy',
                    exclude_director: 'Quentin Tarantino',
                    country: 'USA',
                    rating: 8.9
            price 10
            hall :red, :blue
          end

          session_break '23:00'..'06:00'
        end
      end

      subject { theatre.show("12:00") }
      it { is_expected.to eq 'Fight Club will be shown at 12:00' }
    end
  end
end
