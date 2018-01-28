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
        expect(page).to have_content 'レビューがありません'
        expect(page).to have_link 'レビューを書く', href: new_musician_release_track_review_path(@release.musician, @release, @track)
      end

      context 'when the release has reviews' do
        before { @first_review, @second_review = create_pair(:review, reviewable: @track) }

        it 'displays reviews' do
          visit musician_release_track_path(@release.musician, @release, @track)

          expect(page).to have_link @first_review.user.name, href: user_reviews_path(@first_review.user)
          expect(page).to have_content @first_review.body
          expect(page).to have_link @second_review.user.name, href: user_reviews_path(@second_review.user)
          expect(page).to have_content @second_review.body
        end

        context 'when the user is signing in' do
          before do
            @user = create(:user, confirmed_at: Time.current)
            sign_in @user
          end

          context 'the user reviews do not exist' do
            it 'shows the link to the new review page' do
              visit musician_release_track_path(@release.musician, @release, @track)

              expect(page).to have_link 'レビューを書く', href: new_musician_release_track_review_path(@release.musician, @release, @track)
            end
          end

          context 'when the user reviews exist' do
            before { @first_review.update!(user: @user) }

            it 'shows the link to the review editing page' do
              visit musician_release_track_path(@release.musician, @release, @track)

              expect(page).to have_link 'レビューを書く', href: edit_musician_release_track_review_path(@release.musician, @release, @track, @first_review)
            end
          end
        end
      end
    end
  end
end
