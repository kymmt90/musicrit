require 'rails_helper'

RSpec.describe 'Musicians reviews', type: :system do
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
        expect(page).to have_button '削除する'
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
            @review.reload
          }.not_to change(@review, :body)

          expect(page).to have_content '更新できませんでした'
          expect(page).to have_field 'レビュー'
        end
      end

      context 'when destroying' do
        it 'destroys the review' do
          visit edit_musician_review_path(@musician, @review)

          expect {
            click_button '削除する'
          }.to change(Review, :count).by(-1)

          expect(current_path).to eq musician_path(@musician)
          expect(page).to have_content 'レビューを削除しました'
        end
      end
    end
  end
end
