require 'rails_helper'

RSpec.describe 'Musicians API', type: :request do
  let(:expected_musician) {
    {
      id: Integer,
      name: String,
      begun_in: String,
      description: String
    }
  }

  before do
    @headers = {
      ACCEPT: 'application/vnd.musicrit.v1+json',
      CONTENT: 'application/json'
    }
  end

  describe 'GET /musicians' do
    context 'when musicians do not exist' do
      it 'returns no musicians' do
        get '/musicians', headers: @headers

        expect(response.status).to eq 200
        expected = { musicians: [] }
        expect(response.body).to be_json_as expected
      end
    end

    context 'when musicians exist' do
      before { create_pair(:musician) }

      it 'returns all musicians' do
        get '/musicians', headers: @headers

        expect(response.status).to eq 200
        expected = {
          musicians: [expected_musician] * Musician.count
        }
        expect(response.body).to be_json_as expected
      end
    end
  end

  describe 'GET /musicians/:id' do
    context 'when the musician exists' do
      before { @musician = create(:musician) }
      fit 'returns the musician' do
        get "/musicians/#{@musician.id}", headers: @headers

        expect(response.status).to eq 200
        expected = {
          musician: expected_musician.merge(
            id: @musician.id,
            name: @musician.name,
            begun_in: @musician.begun_in,
            description: @musician.description
          )
        }
        expect(response.body).to be_json_as expected
      end
    end
  end
end
