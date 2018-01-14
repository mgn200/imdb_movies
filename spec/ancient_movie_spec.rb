RSpec.describe ImdbPlayfield::AncientMovie do
  let(:movie_info) {
                     {
                       title: 'Test movie',
                       year:          1944,
                       actors:   'A, B, C',
                       genre:     'Comedy',
                       date:   '1944-04-03',
                       list: nil
                     }
                   }
  subject(:ancient_movie) { ImdbPlayfield::AncientMovie.new(movie_info) }

  describe 'methods and attributes' do
    it {
      is_expected.to have_attributes(price: Money.new(100),
                                     period: :ancient,
                                     to_s: "Test movie - старый фильм(1944 год)" )
    }
  end
end
