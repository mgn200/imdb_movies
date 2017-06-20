RSpec.describe Netflix do
  netflix = Netflix.new(MovieCollection.new('movies.txt'))
  netflix.pay 25

  describe '#show' do
    let(:params) { { period: 'Classic' } }
    let(:initial) { 25 }

    context 'with valid params' do
      subject { netflix.show(params) }
      it { is_expected.to be_a String }

      describe 'changes balance variable' do
        context 'Ancient Movie' do
          let(:params) { { period: 'Ancient' } }
          it { expect { subject }.to change(netflix, :balance).by -1 }
        end

        context 'Modern Movie' do
          let(:params) { { period: 'Modern' } }
          it { expect { subject }.to change(netflix, :balance).by -3 }
        end

        context 'New Movie' do
          let(:params) { { period: 'New'} }
          it { expect { subject }.to change(netflix, :balance).by -5 }
        end

        context 'Classic Movie' do
          let(:params) { { period: 'Classic'} }
          it { expect { subject }.to change(netflix, :balance).by -1.5 }
        end
      end
    end

    context 'with insufficient balance' do
      before { netflix.pay -25 }
      subject { netflix.show(params) }
      it { expect { subject }.to raise_error }
    end
  end

  describe '#pay' do
    subject { netflix }
    it { expect { subject.pay(24) }.to change(netflix, :balance).by 24 }
  end

  describe '#how_much?' do
    subject { netflix.how_much? 'Inception' }
    it { is_expected.to eq 5 }
  end
end
