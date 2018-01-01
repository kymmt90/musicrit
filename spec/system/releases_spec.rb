require 'rails_helper'

RSpec.describe 'Releases', type: :system, js: true do
  describe 'musician_releases_path' do
    before { @musician = create(:musician) }

    it 'redirects to musician_path' do
      visit musician_releases_path(@musician)

      expect(current_path).to eq musician_path(@musician)
    end
  end

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

    context 'when the release has tracks' do
      before { @track_1, @track_2 = create_pair(:track, release: @release) }

      it 'displays tracks' do
        visit musician_release_path(@release.musician, @release)

        expect(page).to have_link @track_1.title, href: musician_release_track_path(@release.musician, @release, @track_1)
        expect(page).to have_link @track_2.title, href: musician_release_track_path(@release.musician, @release, @track_2)
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
      expect(page).to have_field '曲タイトル'
      expect(page).to have_button '登録する'
    end

    context 'when submitting valid data' do
      before do
        @release_attributes = attributes_for(:release)
        @track_attributes = attributes_for(:track)
      end

      it 'creates new release' do
        visit new_musician_release_path(@musician)
        fill_in 'タイトル', with: @release_attributes[:title]
        fill_in 'リリース日', with: @release_attributes[:released_on]
        fill_in '説明', with: @release_attributes[:description]
        fill_in '曲タイトル', with: @track_attributes[:title]

        expect {
          click_button '登録する'
        }.to change(Release, :count).by(1).and change(Track, :count).by(1)

        expect(current_path).to eq musician_release_path(@musician, Release.first)
        expect(page).to have_content '登録しました'
      end
    end

    context 'when submitting invalid data' do
      before do
        @release_attributes = attributes_for(:release)
        @release_attributes[:released_on] = 'XXXX-12-01'
        @track_attributes = attributes_for(:track)
      end

      it 're-render the form' do
        visit new_musician_release_path(@musician)
        fill_in 'タイトル', with: @release_attributes[:title]
        fill_in 'リリース日', with: @release_attributes[:released_on]
        fill_in '説明', with: @release_attributes[:description]
        fill_in '曲タイトル', with: @track_attributes[:title]

        expect {
          click_button '登録する'
        }.not_to change(Release, :count)

        expect(page).to have_content '登録できませんでした'
        expect(page).to have_field 'タイトル'
        expect(page).to have_field 'リリース日'
        expect(page).to have_field '説明'
        expect(page).to have_field '曲タイトル'
        expect(page).to have_button '登録する'
      end
    end
  end

  describe 'edit_release_path' do
    before do
      @release = create(:release)
      @track = create(:track, release: @release)
    end

    it 'shows the form' do
      visit edit_musician_release_path(@release.musician, @release)

      expect(page).to have_field 'タイトル', with: @release.title
      expect(page).to have_field 'リリース日', with: @release.released_on
      expect(page).to have_field '説明', with: @release.description
      expect(page).to have_field '曲タイトル', with: @track.title
      expect(page).to have_button '更新する'
    end

    context 'when submitting valid data' do
      let(:edited_title) { "[UPDATE]#{@release.title}" }

      it 'updates the release' do
        visit edit_musician_release_path(@release.musician, @release)
        fill_in 'タイトル', with: edited_title
        find('#release_tracks__id', visible: false).set @track.id

        expect {
          click_button '更新する'
          @release.reload
        }.to change(@release, :title)

        expect(current_path).to eq musician_release_path(@release.musician, @release)
        expect(page).to have_content '更新しました'
      end
    end

    context 'when submitting invalid data' do
      let(:edited_released_on) { 'XXXX-12-01' }

      it 're-render the form' do
        visit edit_musician_release_path(@release.musician, @release)
        fill_in 'リリース日', with: edited_released_on
        find('#release_tracks__id', visible: false).set @track.id

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
