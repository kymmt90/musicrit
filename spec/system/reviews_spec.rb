require 'rails_helper'

RSpec.describe 'Reviews', type: :system do
  describe 'new_musician_review_path' do
    before { @musician = create(:musician) }

    it 'shows the form' do
      visit new_musician_review_path(@musician)

      expect(page).to have_content @musician.name
      expect(page).to have_field 'レビュー'
      expect(page).to have_button '公開する'
    end
  end

  describe 'user_reviews_path' do
    context 'when not user review exists' do
      before do
        @user = create(:user)
        @user.reviews.clear
      end

      it 'displays messages' do
        visit user_reviews_path(@user)

        expect(page).to have_content 'レビューがありません', count: 3 # musician, release, track
      end
    end

    context 'when user reviews exist' do
      before do
        @user = create(:user)

        musician = create(:musician)
        musician.reviews.create!(attributes_for(:review).merge(user: @user))

        release = create(:release)
        release.reviews.create!(attributes_for(:review).merge(user: @user))

        track = create(:track)
        track.reviews.create!(attributes_for(:review).merge(user: @user))
      end

      it 'display user reviews' do
        visit user_reviews_path(@user)

        expect(page).to have_content @user.reviews.first.reviewable.name
        expect(page).to have_content @user.reviews.first.body
        expect(page).to have_content @user.reviews.first.created_at.to_date

        expect(page).to have_content @user.reviews.second.reviewable.name
        expect(page).to have_content @user.reviews.second.body
        expect(page).to have_content @user.reviews.second.created_at.to_date

        expect(page).to have_content @user.reviews.third.reviewable.name
        expect(page).to have_content @user.reviews.third.body
        expect(page).to have_content @user.reviews.third.created_at.to_date
      end
    end
  end
end
