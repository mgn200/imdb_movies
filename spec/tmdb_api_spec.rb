RSpec.describe TMDBApi do
  let(:tmdb) {TMDBApi.new}
  #stub_request(:get, "https://api.themoviedb.org/3/find/").to_return(body: )
  describe "Sends request to TMDB API and recieves json response" do
    before { msg = tmdb.fetch_info }
    VCR.use_cassette('cassettes/find_movie') do
      it { expect(msg).to 'find_movie' }
    end
  end

  describe "Saves data to YAML file" do
    #it { is_expected.to eq 'asd' }
  end
end
