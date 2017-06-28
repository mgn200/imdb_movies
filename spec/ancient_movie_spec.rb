RSpec.describe AncientMovie do
  let(:list) { nil }
  let(:movie_info) { { title: 'Test movie',
                       year: 1944,
                       actors: 'A, B, C',
                       genre: 'Comedy',
                       date: '1944-04-03'
                   } }
  subject(:ancient_movie) { AncientMovie.new(list, movie_info) }

  describe 'methods and attributes' do
    it {
      is_expected.to have_attributes(price: 1,
                                     period: :ancient,
                                     to_s: "Test movie - старый фильм(1944 год)" )
    }
  end
end
