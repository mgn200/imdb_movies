require 'pry'
RSpec.describe Netflix do
  #build :movie
  let(:netflix) { build :netflix }
  let(:netflix_no_balance) { build(:netflix, balance: 0) }

  it 'initialize balance variable' do
    expect(netflix.balance).to eq 10
  end

  describe '#show' do
    context 'with valid params' do
      it 'returns string with movie info' do
        expect(netflix.show(period: 'Classic', genre: 'Crime').is_a? String).to be true
      end

      describe 'changes balance variable' do
        context 'Ancient Movie' do
          it 'changes balance by 1' do
            expect { netflix.show(period: 'Ancient', genre: 'Crime') }.to change { netflix.balance }.by -1
          end
        end

        context 'Modern Movie' do
          it 'changes balance by 3' do
            expect { netflix.show(period: 'Modern', genre: 'Crime') }.to change { netflix.balance }.by -3
          end
        end

        context 'New Movie' do
          it 'changes balance by 5' do
            expect { netflix.show(period: 'New', genre: 'Crime') }.to change { netflix.balance }.by -5
          end
        end

        context 'Classic Movie' do
          it 'changes balance by 1.5' do
            expect { netflix.show(period: 'Classic', genre: 'Crime') }.to change { netflix.balance }.by -1.5
          end
        end
      end
    end

    context 'with insufficient balance' do
      it 'raises and exception' do
        expect { netflix_no_balance.show(period: 'Ancient') }.to raise_error
      end
    end
  end

  describe '#pay' do
    it 'changes balance' do
      expect { netflix.pay(25) }.to change { netflix.balance }.by 25
    end
  end

  describe '#how_much?' do
    it 'returns price of movie' do
      expect(netflix.how_much? 'NewMovie').to eq 5
    end
  end
end
