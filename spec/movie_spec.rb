# Abstract class
# Тестируеся обработка доп. параметров постера и перевода из YML файла
RSpec.describe MovieProduction::Movie do
  let(:movie) { MovieProduction::MovieCollection.new.all.sample }

  describe '#fetch_additional_info' do
    subject { movie }
    before { movie.fetch_additional_info }

    it { is_expected.to have_attributes(bg_picture, ru_title) }
  end
end
