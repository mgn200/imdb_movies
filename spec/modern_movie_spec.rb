RSpec.describe Movieproduction::ModernMovie do
  let(:list) { nil }
  let(:movie_info) { { title: 'Test movie',
                       year: 1984,
                       actors: 'A, B, C',
                       genre: 'Comedy',
                       date: '1984-04-03'
                    } }

  subject(:modern_movie) { Movieproduction::ModernMovie.new(list, movie_info) }

  describe '#initialze' do
    it {
      is_expected.to have_attributes(period: :modern,
                                     price: Money.new(300),
                                     to_s: 'Test movie - современное кино: играют A, B, C.')
    }
  end
end
