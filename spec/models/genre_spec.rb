require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe '#description' do
    subject { build(:genre, description: description) }

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
    context 'when releases exist' do
      before do
        @genre = create(:genre)
        @release = create(:release, genre: @genre)
      end

      it 'throws an exception' do
        expect { @genre.destroy }.to raise_error ActiveRecord::DeleteRestrictionError
      end
    end

    context 'when sub genres exist' do
      before do
        @genre = create(:genre)
        @sub_genre = create(:sub_genre, genre: @genre)
      end

      it 'destroys sub genres' do
        expect { @genre.destroy }.to change(SubGenre, :count).by(-1)
      end

      context 'when releases also exist' do
        before { @relase = create(:release, genre: @genre) }

        it 'throws an exception' do
          expect { @genre.destroy }.to raise_error ActiveRecord::DeleteRestrictionError
        end
      end
    end
  end

  describe '#name' do
    subject { build(:genre, name: name) }

    context 'when empty' do
      let(:name) { '' }
      it { should be_invalid }
    end

    context 'when nil' do
      let(:name) { nil }
      it { should be_invalid }
    end
  end

  describe '#releases' do
    before { @genre = create(:genre) }
    it { should respond_to :releases }
  end

  describe 'validations' do
    context 'when a record which has same name has already existed' do
      before do
        genre_in_advance = create(:genre)
        attributes = genre_in_advance.attributes.with_indifferent_access.slice(:name, :description)
        @genre = build(:genre, attributes)
      end

      specify 'the later record is invalid' do
        expect(@genre).to be_invalid
      end
    end
  end
end
