RSpec.describe ImdbPlayfield::Cashbox do
  let(:object) { Object.new.extend ImdbPlayfield::Cashbox}

  describe '#cash' do
    subject { object.cash }
    it { is_expected.to be_a Money }
  end

  describe '#store_cash' do
    subject { object.store_cash 2 }
    it { expect { subject }.to change(object, :cash).by Money.new(200) }
  end

  describe '#take' do
    context 'when Bank' do
      before { object.store_cash 10 }
      subject { object.take 'Bank' }
      it { expect(subject).to eq('Проведена инкассация') }
      it { expect { subject }.to change(object, :cash).by Money.new(-1000) }
    end

    context 'when not Bank' do
      subject { object.take 'Not bank' }
      it { expect { subject }.to raise_error ArgumentError, 'Вызываю полицию' }
    end
  end
end
