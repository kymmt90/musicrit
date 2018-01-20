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
