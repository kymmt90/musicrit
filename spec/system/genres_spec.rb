require 'rails_helper'

RSpec.describe 'Genres', type: :system do
  describe 'genres_path' do
    context 'when genres do not exist' do
      it 'display a message' do
        visit genres_path
        expect(page).to have_content 'ジャンルが登録されていません'
      end
    end

    context 'when genres exist' do
      before { @genres = create_pair(:genre) }

      it 'display genres' do
        visit genres_path

        expect(page).to have_content @genres[0].name
        expect(page).to have_content @genres[1].name
      end
    end
  end

  describe 'genre_path' do
    context 'when the genre exists' do
      before { @genre = create(:genre) }

      it 'display the genre' do
        visit genre_path(@genre)

        expect(page).to have_content @genre.name
        expect(page).to have_content @genre.description
      end
    end
  end

  describe 'new_genre_path' do
    it 'shows the form' do
      visit new_genre_path

      expect(page).to have_field 'ジャンル名'
      expect(page).to have_field '説明'
      expect(page).to have_button '登録する'
    end

    context 'when submitting valid data' do
      before { @genre_attributes = attributes_for(:genre) }

      it 'creates new genre' do
        visit new_genre_path
        fill_in 'ジャンル名', with: @genre_attributes[:name]
        fill_in '説明', with: @genre_attributes[:description]

        expect {
          click_button '登録する'
        }.to change(Genre, :count).by(1)

        expect(current_path).to eq genre_path(Genre.first)
        expect(page).to have_content '登録しました'
      end
    end

    context 'when submitting invalid data' do
      before do
        @genre_attributes = attributes_for(:genre)
        @genre_attributes[:name] = ''
      end

      it 're-render the form' do
        visit new_genre_path
        fill_in 'ジャンル名', with: @genre_attributes[:name]
        fill_in '説明', with: @genre_attributes[:description]

        expect {
          click_button '登録する'
        }.not_to change(Genre, :count)

        expect(page).to have_content '登録できませんでした'
        expect(page).to have_field 'ジャンル名'
        expect(page).to have_field '説明'
        expect(page).to have_button '登録する'
      end
    end
  end
end
