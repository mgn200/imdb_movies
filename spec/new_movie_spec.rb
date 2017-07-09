RSpec.describe MovieProduction::NewMovie do
  let(:list) { nil }
  let(:movie_info)  { { title: 'Test movie',
                         year: 2002,
                         actors: 'A, B, C',
                         genre: 'Comedy',
                         date: '2002-04-03'
                       } }

  subject(:new_movie) { MovieProduction::NewMovie.new(list, movie_info) }

  describe '#initialze' do
    it {
      is_expected.to have_attributes(price: Money.new(500),
                                     period: :new,
                                     to_s: 'Test movie - новинка, вышло 15 лет назад!')
    }
  end
end
