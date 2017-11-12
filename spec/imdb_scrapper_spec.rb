RSpec.describe IMDBScrapper do
  # Тестируем запись данных(бюджета) в YML файл после обработки html страницы мувика на imdb.com
  # На примере коллекции из одного мувика
  let(:movie) { ImdbPlayfield::MovieCollection.new.filter(title: 'Fight Club')}
  before { stub_const("IMDBScrapper::YML_FILE_PATH", File.expand_path("spec/yml_data/test_imdb_budget.yml")) }

  describe '#run' do
    it 'creates YML with budget info from imdb' do
      VCR.use_cassette('fight_club_html') do
        IMDBScrapper.run(movie)
        yaml_data = YAML.load_file(IMDBScrapper::YML_FILE_PATH)
        expect(yaml_data['tt0137523'][:budget]).to eq "$63,000,000"
      end
    end
  end
end
