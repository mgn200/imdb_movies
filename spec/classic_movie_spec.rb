RSpec.describe ImdbPlayfield::ClassicMovie do
  let(:list) { ImdbPlayfield::MovieCollection.new }
  let(:movie_info) { { title: 'Test movie',
                       year: 1954,
                       actors: 'A, B, C',
                       genre: 'Comedy',
                       date: '1954-04-03',
                       director: 'Frank Darabont',
                       list: list
                   } }

  subject(:classic_movie) { ImdbPlayfield::ClassicMovie.new(movie_info) }

  describe '#initialze' do
    it {
      is_expected.to have_attributes(price: Money.new(150),
                                     period: :classic,
                                     to_s: "Test movie - классический фильм, режиссёр Frank Darabont(The Shawshank Redemption,The Green Mile)")
    }
  end
end
