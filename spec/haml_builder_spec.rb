RSpec.describe MovieProduction::HamlBuilder do
  let(:movies) { MovieProduction::MovieCollection.new }
  let(:haml_builder) { MovieProduction::HamlBuilder.new(movies) }
  #before { allow(haml_builder).to receive(:haml_layout).and_return("spec/views/test_index.html") }

  describe "#build_html" do
    before {
      allow_any_instance_of(MovieProduction::HamlBuilder).to receive(:html_layout).and_return("spec/views/test_index.html")
      allow_any_instance_of(MovieProduction::HamlBuilder).to receive(:haml_layout).and_return(File.read('spec/views/test_index.haml')) 
    }
    context 'puts succes message' do
      VCR.use_cassette("send_request_response") do
        subject { haml_builder.build_html }
        it { is_expected.to eq 'Index file created' }
      end
    end

    context 'created file with content' do
      VCR.use_cassette("send_request_response") do
        before { haml_builder.build_html }
        let(:file_content) { File.read "spec/views/test_index.html" }
        it { expect(file_content).to_not be nil }
      end
    end
  end
end
