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
        expect(page).to have_link '更新する', href: edit_musician_release_path(@release.musician, @release)
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

    context 'when submitting valid data' do
      before { @release_attributes = attributes_for(:release) }

      it 'creates new release' do
        visit new_musician_release_path(@musician)
        fill_in 'タイトル', with: @release_attributes[:title]
        fill_in 'リリース日', with: @release_attributes[:released_on]
        fill_in '説明', with: @release_attributes[:description]

        expect {
          click_button '登録する'
        }.to change(Release, :count).by(1)

        expect(current_path).to eq musician_release_path(@musician, Release.first)
        expect(page).to have_content '登録しました'
      end
    end

    context 'when submitting invalid data' do
      before do
        @release_attributes = attributes_for(:release)
        @release_attributes[:released_on] = 'XXXX-12-01'
      end

      it 're-render the form' do
        visit new_musician_release_path(@musician)
        fill_in 'タイトル', with: @release_attributes[:title]
        fill_in 'リリース日', with: @release_attributes[:released_on]
        fill_in '説明', with: @release_attributes[:description]

        expect {
          click_button '登録する'
        }.not_to change(Release, :count)

        expect(page).to have_content '登録できませんでした'
        expect(page).to have_field 'タイトル'
        expect(page).to have_field 'リリース日'
        expect(page).to have_field '説明'
        expect(page).to have_button '登録する'
      end
    end
  end

  describe 'edit_release_path' do
    before do
      @release = create(:release)
      @release_attributes = @release.attributes.with_indifferent_access.slice(:title, :released_on, :description)
    end

    it 'shows the form' do
      visit edit_musician_release_path(@release.musician, @release)

      expect(page).to have_field 'タイトル', with: @release_attributes[:title]
      expect(page).to have_field 'リリース日', with: @release_attributes[:released_on]
      expect(page).to have_field '説明', with: @release_attributes[:description]
      expect(page).to have_button '更新する'
    end

    context 'when submitting valid data' do
      before { @release_attributes[:title] = "[UPDATE]#{@release.title}" }

      it 'updates the release' do
        visit edit_musician_release_path(@release.musician, @release)
        fill_in 'タイトル', with: @release_attributes[:title]

        expect {
          click_button '更新する'
          @release.reload
        }.to change(@release, :title)

        expect(current_path).to eq musician_release_path(@release.musician, @release)
        expect(page).to have_content '更新しました'
      end
    end

    context 'when submitting invalid data' do
      before do
        @release_attributes = attributes_for(:release)
        @release_attributes[:released_on] = 'XXXX-12-01'
      end

      it 're-render the form' do
        visit edit_musician_release_path(@release.musician, @release)
        fill_in 'リリース日', with: @release_attributes[:released_on]

        expect {
          click_button '更新する'
          @release.reload
        }.not_to change(@release, :released_on)

        expect(page).to have_content '更新できませんでした'
        expect(page).to have_field 'タイトル'
        expect(page).to have_field 'リリース日'
        expect(page).to have_field '説明'
        expect(page).to have_button '更新する'
      end
    end

    context 'when destroying' do
      it 'destroy the release' do
        visit edit_musician_release_path(@release.musician, @release)

        expect {
          click_button '削除する'
        }.to change(Release, :count).by(-1)

        expect(current_path).to eq musician_path(@release.musician)
        expect(page).to have_content '削除しました'
      end
    end
  end
end
