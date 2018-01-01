require 'rails_helper'

RSpec.describe 'Tracks', type: :system do
  describe 'musician_release_track_path' do
    before { @release = create(:release) }

    context 'when the track exists' do
      before { @track = @release.tracks.create!(attributes_for(:track)) }

      it 'display the track details' do
        visit musician_release_track_path(@release.musician, @release, @track)

        expect(page).to have_content @track.title
        expect(page).to have_content @track.disc_number
        expect(page).to have_content @track.track_number
        expect(page).to have_content @track.description
      end
    end
  end
end
