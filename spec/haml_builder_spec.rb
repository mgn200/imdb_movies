RSpec.describe ImdbPlayfield::HamlBuilder do
  # берем определенный мувик для сравнения данных
  let(:movies) { ImdbPlayfield::MovieCollection.new.filter(title: 'Fight Club') }
  let(:haml_builder) { ImdbPlayfield::HamlBuilder.new(movies) }
  #before { allow(haml_builder).to receive(:haml_layout).and_return("spec/views/test_index.html") }
  describe "Build html file from haml layout" do
    describe "#build_html" do
      before {
        stub_const("ImdbPlayfield::HamlBuilder::HTML_FILE", File.expand_path("spec/views/test_index.html"))
        allow_any_instance_of(ImdbPlayfield::HamlBuilder).to receive(:haml_layout).and_return(File.read('spec/views/test_index.haml'))
      }

      context 'return success message' do
        subject { haml_builder.build_html }
        it { is_expected.to be true }
      end

      context 'created file with content' do
        before { haml_builder.build_html }
        subject { File.read "spec/views/test_index.html" }
        it { is_expected.to have_tag('h6.card-subtitle.mb-2', seen: /USA, 1999, $63,000,000/ )}
        it { is_expected.to have_tag('h4.card-title', seen: "Fight Club (Бойцовский клуб)" )}
        it { is_expected.to have_tag('img.card-img-top', with: { :src => "https://image.tmdb.org/t/p/w640//hTjHSmQGiaUMyIx3Z25Q1iktCFD.jpg" }) }
      end
    end
  end
end
