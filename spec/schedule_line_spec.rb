RSpec.describe ImdbPlayfield::ScheduleLine do
  let(:movie) { ImdbPlayfield::MovieCollection.new.find { |m| m.title == 'City Lights' } }
  subject { ImdbPlayfield::ScheduleLine.new(start: "09:00", movie: movie, halls: [:red]).print }

  describe "#print" do
    it { is_expected.to eq "\t09:00 City Lights(Comedy, Drama, Romance, 1931). Red hall(s).\n" }
  end
end
