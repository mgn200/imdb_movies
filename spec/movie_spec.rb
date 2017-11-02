# Abstract class
# Тестируеся обработка доп. параметров постера и перевода из YML файла
RSpec.describe MovieProduction::Movie do
  let(:movie) { MovieProduction::MovieCollection.new.all.sample }
  describe '#save_additional_info' do
    context 'YAML parser' do
      before { movie.save_additional_info(MovieProduction::Scrappers::Tmdb, :title, :poster_path) }
      it { VCR.use_cassette('send_request_response') { expect(movie.additional_info).not_to be nil } }
    end

    context 'IMDB parser' do
      it {
        VCR.use_cassette('imdb_page') do
         movie.save_additional_info(MovieProduction::Scrappers::Imdb)
         expect(movie.additional_info).not_to be nil
       end
      }
    end
  end
end
