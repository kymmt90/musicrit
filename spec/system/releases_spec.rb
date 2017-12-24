require 'rails_helper'

RSpec.describe 'Releases', type: :system do
  describe 'musician_release_path' do
    before { @release = create(:release, musician: create(:musician)) }

    context 'when the release exists' do
      it 'display the release' do
        visit musician_release_path(@release.musician, @release)

        expect(page).to have_content @release.title
        expect(page).to have_content @release.released_on
        expect(page).to have_content @release.description
      end
    end
  end

  describe 'new_musician_release_path' do
    before { @musician = create(:musician) }

    it 'shows the form' do
      visit new_musician_release_path(@musician)

      expect(page).to have_field 'タイトル'
      expect(page).to have_field 'リリース日'
      expect(page).to have_field '説明'
      expect(page).to have_button '登録する'
    end
  end
end
