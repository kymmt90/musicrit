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
end
