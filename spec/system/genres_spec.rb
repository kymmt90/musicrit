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
end
