# доп. методы для шаблона страницы
RSpec.describe MovieProduction::Movie do
  let(:movie) { MovieProduction::MovieCollection.new.filter(title: 'Fight Club').first}
  describe 'info from YML files' do
    context '#poster' do
      subject { movie.poster }
      it { is_expected.to eq "/hTjHSmQGiaUMyIx3Z25Q1iktCFD.jpg"}
    end

    context '#rus_title' do
      subject { movie.rus_title }
      it { is_expected.to eq "Бойцовский клуб"}
    end

    context '#budget' do
      subject { movie.budget }
      it { is_expected.to eq "$63,000,000" }
    end

    context 'when YML file is not created' do
      before { stub_const("MovieProduction::Movie::TMDB_YML_FILE", "non_existent") }
      subject { movie.rus_title }
      it { is_expected.to eq 'No info' }
    end
  end
end
