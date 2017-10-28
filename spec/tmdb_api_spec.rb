RSpec.describe TMDBApi do
  let(:tmdb) { TMDBApi.new("/home/pfear/projects/imdb_movies/spec/yml_data/test_movies_info.yml") }

  describe "#send_request" do
    let(:key) { tmdb.imdb_keys.first }
    subject { tmdb.send_request(key) }

    context 'response' do
      it 'returns string' do
        VCR.use_cassette('send_request_response') do
          expect(subject.body).to be_an String
        end
      end

      it 'contains json' do
        VCR.use_cassette('send_request_response') do
          expect(JSON.parse(subject.body)).to be_an Hash
        end
      end

      it 'has movie data' do
        VCR.use_cassette('send_request_response') do
          expect(JSON.parse(subject.body)["movie_results"]).to_not be nil
        end
      end
    end
  end

  describe "#fetch data" do
    subject { tmdb.fetch_info }
    context "saves response data to YAML file" do
      it 'can be parsed' do
        VCR.use_cassette('send_request_response') do
          subject
          yaml_data = YAML.load_file('/home/pfear/projects/imdb_movies/spec/yml_data/test_movies_info.yml')
          expect(yaml_data.first.has_key?('poster_path'))
        end
      end
    end

    context "returns ok message" do
      it { VCR.use_cassette('send_request_response') { expect(subject).to eq "OK" } }
    end
  end

  describe "#imdb_keys" do
    subject { tmdb.imdb_keys }
    it { expect(subject.count).to eq 250 }
  end
end
