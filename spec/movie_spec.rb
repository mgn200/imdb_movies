# доп. методы для шаблона страницы
RSpec.describe ImdbPlayfield::Movie do
  let(:movie) { ImdbPlayfield::MovieCollection.new.filter(title: 'Fight Club').first}

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
  end
end
