RSpec.describe MovieProduction::HamlBuilder do
  let(:netflix) { MovieProduction::Netflix.new }
  subject { netflix.build_html(MovieProduction::HamlBuilder) }

  describe "#build_html" do
    it { expect(subject.build_html).to eq 'asd'}
  end
end
