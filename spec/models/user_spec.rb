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
end
