require 'pry'
RSpec.describe Netflix do
  #build :movie
  let(:netflix) { build :netflix }

  it 'initialize balance variable' do
    expect(netflix.balance).to eq 0
  end

  describe '#show' do
    context 'with valid params' do
      it 'returns string with movie info' do
        expect(netflix.show(period: 'Classic', genre: 'Crime').is_a? String).to be true
      end

      describe 'changes balance variable' do
        context 'Ancient Movie' do
          it 'changes balance by 1' do
            expect(netflix.show(period: 'Ancient', genre: 'Crime')).to change { netflix.balance }.by 1
          end
        end

        context 'Modern Movie' do
          it 'changes balance by 3' do
            expect(netflix.show(period: 'Modern', genre: 'Crime')).to change { netflix.balance }.by 3
          end
        end

        context 'New Movie' do
          it 'changes balance by 5' do
            expect(netflix.show(period: 'New', genre: 'Crime')).to change { netflix.balance }.by 5
          end
        end

        context 'Classic Movie' do
          it 'changes balance by 1.5' do
            expect(netflix.show(period: 'Classic', genre: 'Crime')).to change { netflix.balance }.by 1.5
          end
        end
      end
    end
  end

  describe '#pay' do
    #it { is_expected}
  end

  describe '#how_much?' do

  end
end
