RSpec.describe MovieProduction::HamlBuilder do
  let(:movies) { MovieProduction::MovieCollection.new }
  let(:haml_builder) { MovieProduction::HamlBuilder.new(movies) }
  before { allow(haml_builder).to receive(:haml_layout).and_return("%p= @movies_row.count") }

  describe "#build_html" do
    context 'puts succes message' do
      subject { haml_builder.build_html }
      it { is_expected.to eq 'Index file created' }
    end

    context 'created file with content' do
      before { haml_builder.build_html }
      let(:file_content) { File.read "views/index.html" }
      # 6 rows with 2 movies in each row
      it { expect(file_content).to eq "<p>6</p>\n" }
    end
  end
end
