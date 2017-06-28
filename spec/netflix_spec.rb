RSpec.describe Netflix do
  let(:netflix) { Netflix.new }
  let(:params) { { period: :ancient } }
  let(:prepayment) { 10 }
  before { netflix.pay(prepayment) }

  describe '#show' do
    subject { netflix.show(params) }

    context 'with valid params' do
      describe 'changes balance variable' do
        context 'Ancient Movie' do
          it { expect { subject }.to change(netflix, :balance).by -1 }
        end

        context 'Modern Movie' do
          let(:params) { { period: :modern } }
          it { expect { subject }.to change(netflix, :balance).by -3 }
        end

        context 'New Movie' do
          let(:params) { { period: :new } }
          it { expect { subject }.to change(netflix, :balance).by -5 }
        end

        context 'Classic Movie' do
          let(:params) { { period: :classic } }
          it { expect { subject }.to change(netflix, :balance).by -1.5 }
        end
      end

      describe 'Return string' do
        let(:stubed_movie) { MovieCollection.new.filter(title: 'Fight Club').first }

        before {
          allow(netflix).to receive(:pick_movie).and_return(stubed_movie)
          new_time = Time.local(2017, 9, 1, 12, 0, 0)
          Timecop.freeze(new_time)
        }

        context 'Ancient Movie' do
          it { expect(subject).to eq "Now showing: Fight Club 12:00:00 - 14:19:00" }
        end

        context 'Modern Movie' do
          let(:params) { { period: :modern } }

        end
      end
    end

    context 'with invalid params' do
      let(:params) { { period: :wrong } }
      it { expect { subject }.to raise_error(ArgumentError, "Wrong arguments") }
    end


    context 'with insufficient balance' do
      let(:prepayment) { 0.1 }
      it { expect { subject }.to raise_error(RuntimeError, 'Insufficient funds') }
    end
  end

  describe '#pay' do
    it { expect { netflix.pay(24) }.to change(netflix, :balance).by 24 }
    it { expect { netflix.pay(-24) }.to raise_error(ArgumentError, 'Wrong amount') }
  end

  describe '#how_much?' do
    context 'valid params' do
      subject { netflix.how_much? 'Inception' }
      it { is_expected.to eq 5 }
    end

    context 'wrongs params' do
      subject { netflix.how_much? 'Qwerty' }
      it { expect { subject }.to raise_error(ArgumentError, 'No such movie') }
    end
  end
end
