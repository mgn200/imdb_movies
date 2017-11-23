RSpec.describe ImdbPlayfield::TMDBApi do
  # Тестируем создание YML файла с нужными данными на одном заранее известном мувике
  let(:tmdb) { ImdbPlayfield::TMDBApi }
  let(:movies) { ImdbPlayfield::MovieCollection.new.filter(title: 'Fight Club') }

  before { stub_const("ImdbPlayfield::TMDBApi::USER_FILE", File.expand_path("spec/yml_data/test_movies_info.yml")) }

  describe "#fetch_data" do
    it 'creates YML with TMDB movie info' do
      VCR.use_cassette('fight_club_tmdb_request') do
        tmdb.run(movies)
        yaml_data = YAML.load_file(ImdbPlayfield::TMDBApi::USER_FILE)
        expect(yaml_data['tt0137523']['poster_path']).to eq "/hTjHSmQGiaUMyIx3Z25Q1iktCFD.jpg"
        expect(yaml_data['tt0137523']['title']).to eq "Бойцовский клуб"
      end
    end
  end
end
