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
      CONTENT_TYPE: 'application/json'
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

  describe 'POST /musicians' do
    let(:attributes) { attributes_for(:musician) }
    let(:name) { attributes[:name] }
    let(:begun_in) { attributes[:begun_in] }
    let(:description) { attributes[:description] }
    let(:params) {
      {
        musician: {
          name: name,
          begun_in: begun_in,
          description: description
        }
      }
    }

    context 'when valid parameters are submitted' do
      it 'creates a musician' do
        expect {
          post '/musicians', headers: @headers, params: params.to_json
        }.to change(Musician, :count).by(1)

        expect(response.status).to eq 201
        created = Musician.last
        expected = {
          musician: {
            id: created.id,
            name: created.name,
            begun_in: created.begun_in,
            description: created.description
          }
        }
        expect(response.body).to be_json_as expected
      end
    end

    context 'when invalid parameters are submitted' do
      let(:name) { '' }

      it 'creates no musicians' do
        expect {
          post '/musicians', headers: @headers, params: params.to_json
        }.not_to change(Musician, :count)

        expect(response.status).to eq 422
        expected = { errors: [String] }
        expect(response.body).to be_json_as expected
      end
    end
  end

  describe 'GET /musicians/:id' do
    context 'when the musician exists' do
      before { @musician = create(:musician) }
      it 'returns the musician' do
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

  describe 'PATCH /musicians/:id' do
    let(:name) { @musician.name }
    let(:begun_in) { @musician.begun_in }
    let(:description) { @musician.description }
    let(:params) {
      {
        musician: {
          name: name,
          begun_in: begun_in,
          description: description
        }
      }
    }

    before { @musician = create(:musician) }

    context 'when valid parameters are submitted' do
      let(:name) { "[UPDATE]#{@musician.name}" }

      it 'updates the musician' do
        expect {
          patch "/musicians/#{@musician.id}", headers: @headers, params: params.to_json
          @musician.reload
        }.to change(@musician, :name)

        expect(response.status).to eq 200
        expected = {
          musician: {
            id: @musician.id,
            name: @musician.name,
            begun_in: @musician.begun_in,
            description: @musician.description
          }
        }
        expect(response.body).to be_json_as expected
      end
    end

    context 'when invalid parameters are sumitted' do
      let(:name) { '' }

      it 'updates the musician' do
        expect {
          patch "/musicians/#{@musician.id}", headers: @headers, params: params.to_json
          @musician.reload
        }.not_to change(@musician, :name)

        expect(response.status).to eq 422
        expected = { errors: [String] }
        expect(response.body).to be_json_as expected
      end
    end
  end

  describe 'DELETE /musicians/:id' do
    before { @musician = create(:musician) }

    it 'destroys the musician' do
      expect {
        delete "/musicians/#{@musician.id}", headers: @headers
      }.to change(Musician, :count).by(-1)

      expect(response.status).to eq 204
    end
  end
end
