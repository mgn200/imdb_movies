RSpec.describe MovieProduction::Theatre do
  subject do
    MovieProduction::Theatre.new do
      hall :red, title: 'Красный зал', places: 100
      hall :blue, title: 'Синий зал', places: 50
      hall :green, title: 'Зелёный зал (deluxe)', places: 12

      period '09:00'..'11:00' do
        description 'Утренний сеанс'
        params genre: 'Comedy', year: 1900..1980
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
        params genre: ['Action', 'Drama'], year: 2007..Time.now.year
        price 20
        hall :red, :blue
      end

      period '19:00'..'22:00' do
        description 'Вечерний сеанс для киноманов'
        params year: 1900..1945, exclude_country: 'USA'
        price 30
        hall :green
      end
    end
  end

  describe 'Creates Theatre with given block params' do
    it { is_expected.to have_attributes(periods: { ("09:00".."11:00") => { params: { genre: 'Comedy', year: 1900..1980 },
                                                                            description: 'Утренний сеанс',
                                                                            price: 10,
                                                                            hall: [:red, :blue] },
                                                    ("11:00".."16:00") => { description: 'Спецпоказ',
                                                                            title: 'The Terminator',
                                                                            hall: [:green],
                                                                            price: 50 },
                                                    ("16:00".."20:00") => { description: 'Вечерний сеанс',
                                                                            params: { genre: ['Action', 'Drama'], year: 2007..Time.now.year },
                                                                            price: 20,
                                                                            hall: [:red, :blue] },
                                                    ("19:00".."22:00") => { description: 'Вечерний сеанс для киноманов',
                                                                            params: { year: 1900..1945, exclude_country: 'USA' },
                                                                            price: 30,
                                                                            hall: [:green] } },
                                         halls: { :red => { title: 'Красный зал', places: 100 },
                                                  :blue => { title: 'Синий зал', places: 50 },
                                                  :green => { title: 'Зелёный зал (deluxe)', places: 12 }
                                                }
                                          )}


  end
end
