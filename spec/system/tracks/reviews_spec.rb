require 'rails_helper'

RSpec.describe 'Tracks reviews', type: :system do
  describe 'new_musician_release_track_review_path' do
    before do
      @release = create(:release, musician: create(:musician))
      @track = create(:track, release: @release)
    end

    context 'when not signing in' do
      before { @user = create(:user, confirmed_at: Time.current) }

      it 'redirects to the log in form' do
        visit new_musician_release_track_review_path(@release.musician, @release, @track)

        expect(current_path).to eq new_user_session_path
      end
    end

    context 'when signing in' do
      before do
        @user = create(:user, confirmed_at: Time.current)
        sign_in @user
      end

      it 'shows the form' do
        visit new_musician_release_track_review_path(@release.musician, @release, @track)

        expect(page).to have_content @track.title
        expect(page).to have_field 'レビュー'
        expect(page).to have_button '公開する'
      end

      context 'when submitting valid data' do
        before { @review_attributes = attributes_for(:review, :for_track) }

        it 'creates new track review' do
          visit new_musician_release_track_review_path(@release.musician, @release, @track)
          fill_in 'レビュー', with: @review_attributes[:body]

          expect {
            click_button '公開する'
          }.to change(Review, :count).by(1)

          expect(current_path).to eq musician_release_track_path(@release.musician, @release, @track)
          expect(page).to have_content 'レビューを公開しました'
        end
      end

      context 'when submitting invalid data' do
        it 're-render the form' do
          visit new_musician_release_track_review_path(@release.musician, @release, @track)
          fill_in 'レビュー', with: ''

          expect {
            click_button '公開する'
          }.not_to change(Review, :count)

          expect(page).to have_content '公開できませんでした'
          expect(page).to have_field 'レビュー'
        end
      end
    end
  end
end
