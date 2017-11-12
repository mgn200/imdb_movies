RSpec.describe ImdbPlayfield::NewMovie do
  let(:movie_info)  { { title: 'Test movie',
                         year: 2002,
                         actors: 'A, B, C',
                         genre: 'Comedy',
                         date: '2002-04-03',
                         nil: nil
                       } }

  subject(:new_movie) { ImdbPlayfield::NewMovie.new(movie_info) }

  describe '#initialze' do
    it {
      is_expected.to have_attributes(price: Money.new(500),
                                     period: :new,
                                     to_s: 'Test movie - новинка, вышло 15 лет назад!')
    }
  end
end
