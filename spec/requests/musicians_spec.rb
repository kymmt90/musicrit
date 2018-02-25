require 'rails_helper'

RSpec.describe 'Musicians API', type: :request do
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
          musicians: [
            id: Integer,
            name: String,
            begun_in: String,
            description: String
          ] * Musician.count
        }
        expect(response.body).to be_json_as expected
      end
    end
  end
end
