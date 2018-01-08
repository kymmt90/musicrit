require 'rails_helper'

RSpec.describe SubGenre, type: :model do
  describe '#description' do
    subject { build(:sub_genre, description: description) }

    context 'when empty' do
      let(:description) { '' }
      it { should be_valid }
    end

    context 'when nil' do
      let(:description) { nil }
      it { should be_invalid }
    end
  end

  describe '#name' do
    subject { build(:sub_genre, name: name) }

    context 'when empty' do
      let(:name) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:name) { nil }
      it { should be_invalid }
    end
  end

  describe '#genre' do
    subject { build(:sub_genre, genre: genre) }

    context 'when genre is nil' do
      let(:genre) { nil }
      it { should be_invalid }
    end
  end

  describe 'validations' do
    context 'when a record which has same name has already existed' do
      before do
        sub_genre_in_advance = create(:sub_genre)
        attributes = sub_genre_in_advance.attributes.with_indifferent_access.slice(:name, :description)
        @sub_genre = build(:sub_genre, attributes)
      end

      specify 'the later record is invalid' do
        expect(@sub_genre).to be_invalid
      end
    end
  end
end
