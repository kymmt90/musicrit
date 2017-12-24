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
end
