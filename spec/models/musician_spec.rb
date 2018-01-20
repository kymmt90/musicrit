require 'rails_helper'

RSpec.describe Musician, type: :model do
  describe '#name' do
    subject { build(:musician, name: name) }

    context 'when empty' do
      let(:name) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:name) { nil }
      it { should be_invalid }
    end
  end

  describe '#begun_in' do
    subject { build(:musician, begun_in: begun_in) }

    context 'when empty' do
      let(:begun_in) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:begun_in) { nil }
      it { should be_invalid }
    end

    context 'when leading 0' do
      let(:begun_in) { '0990' }
      it { should be_invalid }
    end

    context 'when mixed with alphabets' do
      let(:begun_in) { '199a' }
      it { should be_invalid }
    end
  end

  describe '#description' do
    subject { build(:musician, description: description) }

    context 'when empty' do
      let(:description) { '' }
      it { should be_valid }
    end

    context 'when nil' do
      let(:description) { nil }
      it { should be_invalid }
    end
  end

  describe '#destroy' do
    before do
      @musician = create(:musician)
      @musician.releases.create!(attributes_for(:release))
    end

    it 'destroys associated releases' do
      expect { @musician.destroy }.to change(Release, :count).by(-1)
    end
  end

  describe '#reviews' do
    before do
      @musician = create(:musician)
      @musician.reviews << build(:review)
    end

    it 'destroys associated comments' do
      expect { @musician.destroy }.to change(Review, :count).by(-1)
    end
  end
end
