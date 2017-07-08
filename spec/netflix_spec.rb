RSpec.describe Netflix do
  let(:netflix) { Netflix.new }
  let(:params) { { period: :ancient } }
  let(:prepayment) { 10 }

  describe '#cash' do
    let(:netflix2) { Netflix.new }
    let(:netflix3) { Netflix.new }
    before {
      netflix2.pay 12
      netflix3.pay 1
    }
    it { expect(Netflix.cash).to eq Money.new(1300) }
  end

  describe '#take' do
    before { netflix.pay(prepayment) }
    subject { Netflix.take "Bank" }

    context "when 'Bank' params" do
      it { expect(subject).to eq 'Проведена инкассация' }
      it { expect { subject }.to change(Netflix, :cash).to 0}
    end

    context 'other params' do
      subject { Netflix.take "Another" }
      it { expect { subject }.to raise_error(ArgumentError, 'Вызываю полицию') }
    end
  end

  describe '#show' do
    subject { netflix.show(params) }
    before { netflix.pay(prepayment) }

    context 'with valid params' do
      describe 'changes balance' do
        context 'Ancient Movie' do
          it { expect { subject }.to change(netflix, :balance).to Money.new(900) }
        end

        context 'Modern Movie' do
          let(:params) { { period: :modern } }
          it { expect { subject }.to change(netflix, :balance).to Money.new(700) }
        end

        context 'New Movie' do
          let(:params) { { period: :new } }
          it { expect { subject }.to change(netflix, :balance).to Money.new(500) }
        end

        context 'Classic Movie' do
          let(:params) { { period: :classic } }
          it { expect { subject }.to change(netflix, :balance).to Money.new(850) }
        end
      end

      describe 'Returns string' do
        let(:stubed_movie) { MovieCollection.new.filter(title: 'Fight Club').first }
        before {
          allow(netflix).to receive(:pick_movie).and_return(stubed_movie)
          new_time = Time.local(2017, 9, 1, 12, 0, 0)
          Timecop.freeze(new_time)
        }
        it { expect(subject).to eq "Now showing: Fight Club 12:00:00 - 14:19:00" }
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
    it { expect { netflix.pay(24) }.to change(netflix, :balance).by Money.new(2400) }
    it { expect { netflix.pay(-24) }.to raise_error(ArgumentError, 'Wrong amount') }
    it { expect { netflix.pay(23) }.to change(Netflix, :cash).by Money.new(2300) }
  end

  describe '#store_cash' do
    it { expect { Netflix.store_cash 12 }.to change(Netflix, :cash).by Money.new(1200) }
  end

  describe '#how_much?' do
    context 'valid params' do
      subject { netflix.how_much? 'Inception' }
      it { is_expected.to eq "$5.00" }
    end

    context 'wrongs params' do
      subject { netflix.how_much? 'Qwerty' }
      it { expect { subject }.to raise_error(ArgumentError, 'No such movie') }
    end
  end
end
