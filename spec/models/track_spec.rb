require 'rails_helper'

RSpec.describe Track, type: :model do
  describe '#description' do
    subject { build_stubbed(:track, description: description) }

    context 'when nil' do
      let(:description) { nil }
      it { should be_invalid }
    end

    context 'when empty' do
      let(:description) { '' }
      it { should be_valid }
    end
  end

  describe '#disc_number' do
    subject { build_stubbed(:track, disc_number: disc_number) }

    context 'when nil' do
      let(:disc_number) { nil }
      it { should be_invalid }
    end

    context 'when not positive' do
      let(:disc_number) { 0 }
      it { should be_invalid }
    end
  end

  describe '#title' do
    subject { build_stubbed(:track, title: title) }

    context 'when nil' do
      let(:title) { nil }
      it { should be_invalid }
    end

    context 'when empty' do
      let(:title) { '' }
      it { should be_invalid }
    end
  end

  describe '#track_number' do
    subject { build_stubbed(:track, track_number: track_number) }

    context 'when nil' do
      let(:track_number) { nil }
      it { should be_invalid }
    end

    context 'when not positive' do
      let(:track_number) { 0 }
      it { should be_invalid }
    end
  end

  describe 'validations' do
    context 'when a track which has same release and track_number has already existed' do
      before do
        release = create(:release)
        track_in_advance = create(:track, release: release)
        @track = build(:track, release: release, track_number: track_in_advance.track_number)
      end

      specify 'the later track is invalid' do
        expect(@track).to be_invalid
      end
    end
  end

  describe '#reviews' do
    before do
      @track = create(:track)
      @track.reviews << build(:review)
    end

    it 'destroys associated comments' do
      expect { @track.destroy }.to change(Review, :count).by(-1)
    end
  end
end
