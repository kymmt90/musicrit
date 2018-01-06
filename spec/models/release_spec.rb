require 'rails_helper'

RSpec.describe Release, type: :model do
  describe '#description' do
    subject { build(:release, description: description) }

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
      @release = create(:release)
      @release.tracks.create!(attributes_for(:track))
    end

    it 'destroys associated tracks' do
      expect { @release.destroy }.to change(Track, :count).by(-1)
    end
  end

  describe '#genre' do
    subject { build(:release, genre: genre) }

    context 'when genre is nil' do
      let(:genre) { nil }
      it { should be_valid }
    end
  end

  describe '#released_on' do
    subject { build(:release, released_on: released_on) }

    context 'when empty' do
      let(:released_on) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:released_on) { nil }
      it { should be_invalid }
    end

    context 'when leading 0' do
      let(:released_on) { '0990-01-18' }
      it { should be_invalid }
    end

    context 'when mixed with alphabets' do
      let(:released_on) { '199a-01-18' }
      it { should be_invalid }
    end
  end

  describe '#title' do
    subject { build(:release, title: title) }

    context 'when empty' do
      let(:title) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:title) { nil }
      it { should be_invalid }
    end
  end

  describe 'validations' do
    context 'when a record which has same name, title and released_on has already existed' do
      before do
        musician = create(:musician)
        released_in_advance = create(:release, musician: musician)
        attributes = released_in_advance.attributes.with_indifferent_access.slice(:title, :released_on)
        @release = build(:release, attributes.merge(musician: released_in_advance.musician))
      end

      specify 'the later record is invalid' do
        expect(@release).to be_invalid
      end
    end
  end
end
