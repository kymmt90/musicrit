require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '#body' do
    subject { build_stubbed(:review, body: body) }

    context 'when empty' do
      let(:body) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:body) { nil }
      it { should be_invalid }
    end
  end

  describe '#user' do
    subject { build_stubbed(:review) }
    it { should respond_to :user }
  end
end
