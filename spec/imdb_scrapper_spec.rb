RSpec.describe ImdbPlayfield::IMDBScrapper do
  # Тестируем запись данных(бюджета) в YML файл после обработки html страницы мувика на imdb.com
  # На примере коллекции из одного мувика
  let(:movie) { ImdbPlayfield::MovieCollection.new.filter(title: 'Fight Club')}
  let(:imdb_scrapper) { ImdbPlayfield::IMDBScrapper }
  #before { allow(imdb_scrapper).to receive(:yml_file_path).and_return(File.expand_path("spec/yml_data/test_imdb_budget.yml")) }
  before { stub_const("ImdbPlayfield::IMDBScrapper::USER_FILE", File.expand_path("spec/yml_data/test_imdb_budget.yml")) }

  describe '#run' do
    it 'creates YML with budget info from imdb' do
      VCR.use_cassette('fight_club_html') do
        imdb_scrapper.run(movie)
        yaml_data = YAML.load_file(ImdbPlayfield::IMDBScrapper::USER_FILE)
        expect(yaml_data['tt0137523'][:budget]).to eq "$63,000,000"
      end
    end
  end
end
