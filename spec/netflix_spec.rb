RSpec.describe Netflix do
  let(:netflix) { Netflix.new }
  before { netflix.pay 10 }

  describe '#show' do
    let(:params) { { period: :classic } }

    context 'with valid params' do
      subject { netflix.show(params) }
      it { is_expected.to be_a String }

      describe 'changes balance variable' do
        context 'Ancient Movie' do
          context 'valid params' do
            let(:params) { { period: :ancient } }
            it { expect { subject }.to change(netflix, :balance).by -1 }
            it { expect { subject }.to eq "Now showing: #{movie.title} #{start_end(movie)}" }
          end

          context 'invalid params' do
            let(:params) { { period: :wrong } }
            it { expect { subject }.to eq "Wrong period name" }
          end
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
    end

    context 'with insufficient balance' do
      before { netflix.pay 0.1 }
      subject { netflix.show(params) }
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
    #цену тянуть из Movie?
    context 'wrongs params' do
      subject { netflix.how_much? 'Qwerty' }
      it { expect { subject }.to raise_error(ArgumentError, 'No such movie') }
    end
  end
end
