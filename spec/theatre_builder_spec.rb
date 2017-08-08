RSpec.describe MovieProduction::Theatre do
  subject do
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
    end
  end

  describe 'Creates Theatre with given block params' do
    it { is_expected.to have_attributes(periods: { ("06:00".."12:00") => { params: { period: :ancient },
                                                                      daytime: :morning,
                                                                      price: 3 },
                                              ("12:00".."18:00") => { params: { genre: %w[Comedy Adventure] },
                                                                      daytime: :afternoon,
                                                                      price: 5 },
                                              ("18:00".."24:00") => { params: { genre: %w[Drama Horror] },
                                                                      daytime: :evening,
                                                                      price: 10 },
                                              ("00:00".."06:00") => { params: 'Working hours: 06:00 - 00:00' } },
                                   halls: { :red => { title: 'Красный зал', places: 100 },
                                            :blue => { title: 'Синий зал', places: 50 },
                                            :green => { title: 'Зелёный зал (deluxe)', places: 12 } } )
                                          }
  end
end
