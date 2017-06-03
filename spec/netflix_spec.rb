require 'pry'
RSpec.describe Netflix do
  let(:netflix) { Netflix.new }

  it 'has balance variable' do
    expect(netflix.balance).to eq 0
  end

  describe '#show' do
    context 'with valid params' do
      it { is_expected.to be Array }
      #it { is_expected.to change(Netflix.balance).by }
    end

    context 'with invalid params' do
      it { is_expected.to raise ArgumentError }
    end
  end

  describe '#pay' do
    #it { is_expected}
  end

  describe '#how_much?' do

  end
end
