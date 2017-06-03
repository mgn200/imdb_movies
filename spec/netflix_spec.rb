require './netflix.rb'
RSpec.describe Netflix do
  describe '#show' do
    context 'with valid params' do
      it { is_expected.to recieve Array }
      #it { is_expected.to }
    end

    context 'with invalid params' do
      it { is_expected.to raise ArgumentError }
    end
    end
  end
end
