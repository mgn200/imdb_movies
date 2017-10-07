RSpec.describe MovieProduction::ScheduleLine do
  let(:movie) { MovieProduction::MovieCollection.new.find { |m| m.title == 'City Lights' } }
  subject { MovieProduction::ScheduleLine.new(start: "09:00", movie: movie, halls: [:red]).print }

  describe "#print" do
    it { is_expected.to eq "\t09:00 City Lights(Comedy, Drama, Romance, 1931). Red hall(s).\n" }
  end
end
