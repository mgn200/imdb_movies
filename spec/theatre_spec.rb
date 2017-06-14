RSpec.describe Theatre do
  let(:theatre) { build :theatre }

  describe '#get_period' do
    context '06:00 - 12:00' do
      it 'returns valid hash' do
        params = { period: 'Ancient' }
        expect(theatre.get_time("07:22")).to eq params
      end
    end

    context '12:00 - 18:00' do
      it 'returns valid hash' do
        params = { genre: ['Comedy', 'Adventure'] }
        expect(theatre.get_time("12:22")).to eq params
      end
    end

    context '18:00 - 24:00' do
      it 'return valid hash' do
        params = { genre: ['Drama', 'Horror'] }
        expect(theatre.get_time("18:22")).to eq params
      end
    end
  end

  describe '#show' do
    describe 'different time params' do
      context '6:00 - 12:00' do
        it 'show ancient movies' do
          expect(theatre.show('10:04')).to eq "AncientMovie will be shown at 10:04"
        end
      end

      context '12:00 - 18:00' do
        it 'show comedies and adventures' do
          expect(theatre.show('12:04')).to eq "ModernMovie will be shown at 12:04"
        end
      end

      context '18:00 - 24:00' do
        it 'show dramas and horrors' do
          expect(theatre.show('18:04')).to eq "HorrorMovie will be shown at 18:04"
        end
      end
    end
  end

  describe '#when?' do
    context 'with valid params' do
      it 'returns time range for horrors and dramas' do
        expect(theatre.when?('HorrorMovie')).to eq ('18:00'..'24:00')
      end

      it 'returns time range for comedy and dventures' do
        expect(theatre.when?('ModernMovie')).to eq ('12:00'..'18:00')
      end

      it 'returns time ragne for ancient movies' do
        expect(theatre.when?('AncientMovie')).to eq ('06:00'..'12:00')
      end
    end

    context 'with invalid params' do
      it 'returns message' do
        expect(theatre.when?('TestMovie')).to eq 'No such movie'
      end
    end
  end
end
