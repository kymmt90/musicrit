require 'rails_helper'

RSpec.describe 'Reviews', type: :system do
  describe 'new_musician_review_path' do
    before { @musician = create(:musician) }

    context 'when not signing in' do
      before { @user = create(:user, confirmed_at: Time.current) }

      it 'redirects to the log in form' do
        visit new_musician_review_path(@musician)

        expect(current_path).to eq new_user_session_path
      end
    end

    context 'when signing in' do
      before do
        @user = create(:user, confirmed_at: Time.current)
        sign_in @user
      end

      it 'shows the form' do
        visit new_musician_review_path(@musician)

        expect(page).to have_content @musician.name
        expect(page).to have_field 'レビュー'
        expect(page).to have_button '公開する'
      end

      context 'when submitting valid data' do
        before { @review_attributes = attributes_for(:review) }

        it 'creates new musician review' do
          visit new_musician_review_path(@musician)
          fill_in 'レビュー', with: @review_attributes[:body]

          expect {
            click_button '公開する'
          }.to change(Review, :count).by(1)

          expect(current_path).to eq musician_path(@musician)
          expect(page).to have_content 'レビューを公開しました'
        end
      end

      context 'when submitting invalid data' do
        it 're-render the form' do
          visit new_musician_review_path(@musician)
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

  describe 'edit_musician_review_path' do
    before do
      @user = create(:user, confirmed_at: Time.current)
      @review = create(:review, :for_musician, user: @user)
      @musician = @review.musician
    end

    context 'when not signing in' do
      before { @user = create(:user, confirmed_at: Time.current) }

      it 'redirects to the log in form' do
        visit edit_musician_review_path(@musician, @review)

        expect(current_path).to eq new_user_session_path
      end
    end

    context 'when signing in' do
      before { sign_in @user }

      it 'shows the form' do
        visit edit_musician_review_path(@musician, @review)

        expect(page).to have_content @musician.name
        expect(page).to have_field 'レビュー', with: @review.body
        expect(page).to have_button '更新する'
      end

      context 'when submitting valid data' do
        before { @review_attributes = attributes_for(:review) }

        it 'updates the musician review' do
          visit edit_musician_review_path(@musician, @review)
          fill_in 'レビュー', with: @review_attributes[:body]

          expect {
            click_button '更新する'
            @review.reload
          }.to change(@review, :body)

          expect(current_path).to eq musician_path(@musician)
          expect(page).to have_content 'レビューを更新しました'
        end
      end

      context 'when submitting invalid data' do
        it 're-render the form' do
          visit edit_musician_review_path(@musician, @review)
          fill_in 'レビュー', with: ''

          expect {
            click_button '更新する'
          }.not_to change(@review, :body)

          expect(page).to have_content '更新できませんでした'
          expect(page).to have_field 'レビュー'
        end
      end
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
