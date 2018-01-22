require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#authentications' do
    subject { build_stubbed(:user) }
    it { should respond_to :authentications }
  end

  describe '#destroy' do
    before do
      @user = create(:user)
      @user.authentications.create!(attributes_for(:authentication))
    end

    it 'destroys associated authentications' do
      expect { @user.destroy }.to change(Authentication, :count).by(-1)
    end
  end

  describe '#name' do
    subject { build_stubbed(:user, name: name) }

    context 'when empty' do
      let(:name) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:name) { nil }
      it { should be_invalid }
    end

    context 'when length is equal to 15' do
      let(:name) { 'a' * 15 }
      it { should be_valid }
    end

    context 'when length is greater than 15' do
      let(:name) { 'a' * 16 }
      it { should be_invalid }
    end

    context 'when including characters others than alphabet and underscore' do
      let(:name) { 'abc-123%#' }
      it { should be_invalid }
    end

    context 'when the same name has already existed' do
      before do
        name = 'foo_bar'
        create(:user, name: name)
        @user = build(:user, name: name)
      end

      specify 'each user name is unique' do
        expect(@user).to be_invalid
      end
    end
  end

  describe '#reviews' do
    before do
      @user = create(:user)
      @user.reviews << build(:review, :for_musician)
    end

    it 'destroys associated reviews' do
      expect { @user.destroy }.to change(Review, :count).by(-1)
    end
  end
end
