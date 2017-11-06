RSpec.describe MovieProduction::Netflix do
  let(:netflix) { MovieProduction::Netflix.new }
  let(:params) { { period: :ancient } }
  let(:prepayment) { 10 }

  def freeze_time
    new_time = Time.local(2017, 9, 1, 12, 0, 0)
    Timecop.freeze(new_time)
  end

  describe '#cash' do
    let(:netflix2) { MovieProduction::Netflix.new }
    let(:netflix3) { MovieProduction::Netflix.new }
    before {
      netflix2.pay 12
      netflix3.pay 1
    }
    it { expect(MovieProduction::Netflix.cash).to eq Money.new(1300) }
  end

  describe '#take' do
    before { netflix.pay(prepayment) }
    subject { MovieProduction::Netflix.take "Bank" }

    context "when 'Bank' params" do
      it { expect(subject).to eq 'Проведена инкассация' }
      it { expect { subject }.to change(MovieProduction::Netflix, :cash).to 0 }
    end

    context 'other params' do
      subject { MovieProduction::Netflix.take "Another" }
      it { expect { subject }.to raise_error(ArgumentError, 'Вызываю полицию') }
    end
  end

  describe '#show' do
    subject { netflix.show(params) }
    before do
      netflix.pay(prepayment)
      freeze_time
    end

    context 'when valid hash is passed' do
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
        context 'single param' do
          let(:stubed_movie) { MovieProduction::MovieCollection.new.filter(title: 'Fight Club').first }
          before { allow(netflix).to receive(:pick_movie).and_return(stubed_movie) }
          it { expect(subject).to eq "Now showing: Fight Club 12:00:00 - 14:19:00" }
        end

        context 'multiple params' do
          let(:params) { { period: :modern, title: 'Fight Club' } }
          it { expect(subject).to eq "Now showing: Fight Club 12:00:00 - 14:19:00" }
        end
      end
    end

    context 'when block is passed' do
      let(:params) { proc { |movie| movie.genre.include?('Drama') && movie.director == 'David Fincher' && movie.year == 1999 } }
      subject { netflix.show &params }
      describe 'changes balance' do
        it { expect { subject }.to change(netflix, :balance).to Money.new(700) }
      end

      describe 'returns string' do
        before { freeze_time }
        it { expect(subject).to eq "Now showing: Fight Club 12:00:00 - 14:19:00" }
      end
    end

    context 'when user filters are passed' do
      before do
        netflix.define_filter(:test_filter) { |movie| movie.genre.include?('Drama') &&
                                                      movie.director == 'David Fincher' &&
                                                      movie.actors.include?('Brad Pitt') &&
                                                      movie.year > 1998 }
      end
      subject { netflix.show(test_filter: true) }
      it { expect(subject).to eq "Now showing: Fight Club 12:00:00 - 14:19:00" }

      context 'multiple filters' do
        before do
          netflix.define_filter(:filter1) { |movie| movie.genre.include?('Drama') &&
                                                    movie.director == 'David Fincher' }
          netflix.define_filter(:filter2) { |movie| movie.actors.include?('Brad Pitt') &&
                                                    movie.year > 1998 }
        end
        subject { netflix.show(filter1: true, filter2: true) }
        it { expect(subject).to eq "Now showing: Fight Club 12:00:00 - 14:19:00" }
      end
    end

    context 'when both filter and block is passed' do
      before do
        netflix.define_filter(:test_filter) { |movie| movie.genre.include?('Drama') &&
                                                      movie.year == 1999 }
      end
      subject { netflix.show(test_filter:true) { |movie| movie.director == 'David Fincher'} }
      it { expect(subject).to eq "Now showing: Fight Club 12:00:00 - 14:19:00" }
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
    it { expect { netflix.pay(23) }.to change(MovieProduction::Netflix, :cash).by Money.new(2300) }
  end

  describe '#store_cash' do
    it { expect { MovieProduction::Netflix.store_cash 12 }.to change(MovieProduction::Netflix, :cash).by Money.new(1200) }
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

  describe '#define_filter' do
    before do
      netflix.pay 5
      netflix.define_filter(:test_filter) { |movie| movie.genre.include?('Drama') &&
                                                    movie.director == 'David Fincher' &&
                                                    movie.year == 1999 }
    end

    context 'saves user filters' do
      subject { netflix.user_filters }
      it { expect(subject).not_to be nil }
    end

    context 'used by user' do
      subject { netflix.show(test_filter: true) }
      it { expect(subject).to eq "Now showing: Fight Club 12:00:00 - 14:19:00" }
    end

    context 'changes existing filter' do
      before do
        netflix.define_filter(:test_filter) { |movie, year| movie.year > year && movie.title == 'The Avengers' }
        freeze_time
      end
      subject { netflix.show(test_filter: 2008)}
      it { expect(subject).to eq "Now showing: The Avengers 12:00:00 - 14:23:00" }
    end

    context 'creates filter based on another' do
      before do
        netflix.define_filter(:test_filter) { |movie, year| movie.year > year &&
                                                            movie.genre.include?('Drama') &&
                                                            movie.director == 'Roman Polanski'}
        netflix.define_filter(:new_test_filter, from: :test_filter, arg: 2000)
        freeze_time
      end
      subject { netflix.show(new_test_filter: true) }
      it { expect(subject).to eq "Now showing: The Pianist 12:00:00 - 14:30:00" }
    end
  end

  describe "#build_html" do
    let(:movies) { MovieProduction::MovieCollection.new.filter(title: 'Fight Club') }

    before {
      stub_const("MovieProduction::HamlBuilder::HTML_FILE", "spec/views/test_index.html")
      allow_any_instance_of(MovieProduction::HamlBuilder).to receive(:haml_layout).and_return(File.read('spec/views/test_index.haml'))
    }

    subject { netflix.build_html(MovieProduction::HamlBuilder, movies) }
    it { is_expected.to eq 'Index file created' }
  end
end
