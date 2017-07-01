RSpec.describe ClassicMovie do
  let(:list) { MovieCollection.new }
  let(:movie_info) { { title: 'Test movie',
                       year: 1954,
                       actors: 'A, B, C',
                       genre: 'Comedy',
                       date: '1954-04-03',
                       director: 'Frank Darabont'
                   } }

  subject(:classic_movie) { ClassicMovie.new(list, movie_info) }

  describe '#initialze' do
    it {
      is_expected.to have_attributes(price: 1.5,
                                     period: :classic,
                                     to_s: "Test movie - классический фильм, режиссёр Frank Darabont(The Shawshank Redemption,The Green Mile)")
    }
  end
end
