require 'rails_helper'

RSpec.describe Authentication, type: :model do
  describe 'auth_hash' do
    before do
      @authentication = build(:authentication)
      @authentication.auth_hash = auth_hash
    end

    context 'when valid auth hash' do
      let(:auth_hash) { { provider: 'facebook', uid: '1234567' } }
      it 'decrypts auth hash' do
        expect(@authentication.auth_hash).to eq auth_hash
      end
    end
  end

  describe '#encrypted_auth_hash' do
    subject { build(:authentication, encrypted_auth_hash: encrypted_auth_hash) }

    context 'when empty' do
      let(:encrypted_auth_hash) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:encrypted_auth_hash) { nil }
      it { should be_invalid }
    end
  end

  describe '#provider' do
    subject { build(:authentication, provider: provider) }

    context 'when empty' do
      let(:provider) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:provider) { nil }
      it { should be_invalid }
    end

    context 'when a record which has same uid has already existed' do
      before do
        authentication_in_advance = create(:authentication)
        attributes = authentication_in_advance.attributes.with_indifferent_access.slice(:provider, :uid)
        @authentication = build(:authentication, attributes.merge(user: authentication_in_advance.user))
      end

      specify 'the latter record is invalid' do
        expect(@authentication).to be_invalid
      end
    end
  end

  describe '#uid' do
    subject { build(:authentication, uid: uid) }

    context 'when empty' do
      let(:uid) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:uid) { nil }
      it { should be_invalid }
    end
  end
end
