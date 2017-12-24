require 'rails_helper'

RSpec.describe 'Musicians', type: :system do
  describe 'musicians_path' do
    context 'when no musician exists' do
      it 'displays message' do
        visit musicians_path

        expect(page).to have_content 'ミュージシャンが登録されていません'
      end
    end

    context 'when one musician exists' do
      before { @musician = create(:musician) }

      it 'displays the musician' do
        visit musicians_path

        expect(page).to have_content @musician.name
        expect(page).to have_content @musician.begun_in
      end

      it 'shows the link to each musician' do
        visit musicians_path

        expect(page).to have_link @musician.name, href: musician_path(@musician)
      end
    end

    context 'when musicians exist' do
      before { @musician_1, @musician_2 = create_pair(:musician) }

      it 'displays all musicians list' do
        visit musicians_path

        expect(page).to have_content @musician_1.name
        expect(page).to have_content @musician_2.name
        expect(page).to have_content @musician_1.begun_in
        expect(page).to have_content @musician_2.begun_in
      end
    end
  end

  describe 'musician_path' do
    before { @musician = create(:musician) }

    context 'when the musician exists' do
      context 'when the musician has no releases' do
        it 'displays only the musician' do
          visit musician_path(@musician)

          expect(page).to have_content @musician.name
          expect(page).to have_content @musician.begun_in
          expect(page).to have_content @musician.description
          expect(page).to have_content 'リリースが登録されていません'
        end
      end

      context 'when the musician has releases' do
        before { @first_release, @second_release = create_pair(:release, musician: @musician) }

        it 'displays the musician' do
          visit musician_path(@musician)

          expect(page).to have_content @musician.name
          expect(page).to have_content @musician.begun_in
          expect(page).to have_content @musician.description
        end

        it 'displays releases' do
          visit musician_path(@musician)

          expect(page).to have_content @first_release.title
          expect(page).to have_content @first_release.released_on
          expect(page).to have_content @second_release.title
          expect(page).to have_content @second_release.released_on
        end
      end
    end
  end

  describe 'new_musician_path' do
    it 'shows the form' do
      visit new_musician_path

      expect(page).to have_field '名前'
      expect(page).to have_field '活動開始年'
      expect(page).to have_field 'バイオグラフィ'
      expect(page).to have_button '登録する'
    end

    context 'when submitting valid data' do
      before { @musician_attributes = attributes_for(:musician) }

      it 'creates new musician' do
        visit new_musician_path
        fill_in '名前', with: @musician_attributes[:name]
        fill_in '活動開始年', with: @musician_attributes[:begun_in]
        fill_in 'バイオグラフィ', with: @musician_attributes[:description]

        expect {
          click_button '登録する'
        }.to change(Musician, :count).by(1)

        expect(current_path).to eq musician_path(Musician.first)
        expect(page).to have_content '登録しました'
      end
    end

    context 'when submitting invalid data' do
      before do
        @musician_attributes = attributes_for(:musician)
        @musician_attributes[:begun_in] = 'XXXX'
      end

      it 're-render the form' do
        visit new_musician_path
        fill_in '名前', with: @musician_attributes[:name]
        fill_in '活動開始年', with: @musician_attributes[:begun_in]
        fill_in 'バイオグラフィ', with: @musician_attributes[:description]

        expect {
          click_button '登録する'
        }.not_to change(Musician, :count)

        expect(page).to have_content '登録できませんでした'
        expect(page).to have_field '名前'
        expect(page).to have_field '活動開始年'
        expect(page).to have_field 'バイオグラフィ'
        expect(page).to have_button '登録する'
      end
    end
  end

  describe 'edit_musician_path' do
    before do
      @musician = create(:musician)
      @musician_attributes = @musician.attributes.with_indifferent_access.slice(:name, :begun_in, :description)
    end

    it 'shows the form' do
      visit edit_musician_path(@musician)

      expect(page).to have_field '名前', with: @musician_attributes[:name]
      expect(page).to have_field '活動開始年', with: @musician_attributes[:begun_in]
      expect(page).to have_field 'バイオグラフィ', with: @musician_attributes[:description]
      expect(page).to have_button '更新する'
      expect(page).to have_button '削除する'
    end

    context 'when submitting valid data' do
      before { @musician_attributes[:name] = "[UPDATE]#{@musician.name}" }

      it 'updates the musician' do
        visit edit_musician_path(@musician)
        fill_in '名前', with: @musician_attributes[:name]

        expect {
          click_button '更新する'
          @musician.reload
        }.to change(@musician, :name)

        expect(current_path).to eq musician_path(@musician)
        expect(page).to have_content '更新しました'
      end
    end

    context 'when submitting invalid data' do
      before { @musician_attributes[:begun_in] = 'XXXX' }

      it 're-render the form' do
        visit edit_musician_path(@musician)
        fill_in '活動開始年', with: @musician_attributes[:begun_in]

        expect {
          click_button '更新する'
        }.not_to change(Musician, :count)

        expect(page).to have_content '更新できませんでした'
        expect(page).to have_field '名前'
        expect(page).to have_field '活動開始年'
        expect(page).to have_field 'バイオグラフィ'
        expect(page).to have_button '更新する'
        expect(page).to have_button '削除する'
      end
    end

    context 'when destroying' do
      it 'destroy the musician' do
        visit edit_musician_path(@musician)

        expect {
          click_button '削除する'
        }.to change(Musician, :count).by(-1)

        expect(current_path).to eq musicians_path
        expect(page).to have_content '削除しました'
      end
    end
  end
end
