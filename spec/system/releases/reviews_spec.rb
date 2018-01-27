require 'rails_helper'

RSpec.describe 'Releases reviews', type: :system do
  describe 'new_musician_release_review_path' do
    before { @release = create(:release, musician: create(:musician)) }

    context 'when not signing in' do
      before { @user = create(:user, confirmed_at: Time.current) }

      it 'redirects to the log in form' do
        visit new_musician_release_review_path(@release.musician, @release)

        expect(current_path).to eq new_user_session_path
      end
    end

    context 'when signing in' do
      before do
        @user = create(:user, confirmed_at: Time.current)
        sign_in @user
      end

      it 'shows the form' do
        visit new_musician_release_review_path(@release.musician, @release)

        expect(page).to have_content @release.title
        expect(page).to have_field 'レビュー'
        expect(page).to have_button '公開する'
      end

      context 'when submitting valid data' do
        before { @review_attributes = attributes_for(:review, :for_release) }

        it 'creates new release review' do
          visit new_musician_release_review_path(@release.musician, @release)
          fill_in 'レビュー', with: @review_attributes[:body]

          expect {
            click_button '公開する'
          }.to change(Review, :count).by(1)

          expect(current_path).to eq musician_release_path(@release.musician, @release)
          expect(page).to have_content 'レビューを公開しました'
        end
      end
    end
  end
end
