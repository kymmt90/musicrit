require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before { Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] }

  describe 'edit_user_registration_path' do
    context 'when the user has already signed up with email' do
      before do
        email = attributes_for(:user)[:email]
        OmniAuth.config.add_mock(:facebook, { provider: 'facebook', uid: rand(10000), info: { email: email }})
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

        @user = create(:user, email: email, confirmed_at: Time.current)
        sign_in @user
      end

      it 'connects the user and Facebook authentication' do
        visit edit_user_registration_path

        expect {
          click_link 'Connect with Facebook'
        }.to change(Authentication, :count).by(1)
        expect(Authentication.first.provider).to eq 'facebook'

        expect(current_path).to eq root_path
        expect(page).to have_content '連携しました'
      end

      it 'changes the user name' do
        visit edit_user_registration_path
        fill_in 'ユーザー名', with: 'updated'

        expect {
          click_button 'Update'
          @user.reload
        }.to change(@user, :name)

        expect(current_path).to eq root_path
      end
    end
  end

  describe 'new_user_registration_path' do
    context 'when using Facebook' do
      before do
        email = attributes_for(:user)[:email]
        OmniAuth.config.add_mock(:facebook, { provider: 'facebook', uid: rand(10000), info: { email: email }})
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      end

      it 'creates new registration with Facebook authentication' do
        visit new_user_registration_path
        click_link 'Sign in with Facebook'
        fill_in 'ユーザー名', with: attributes_for(:user)[:name]

        expect {
          click_button 'Sign up'
        }.to change(Authentication, :count).by(1).and change(User, :count).by(1)
        expect(Authentication.first.provider).to eq 'facebook'
      end
    end

    context 'when using Twitter' do
      before do
        OmniAuth.config.add_mock(:twitter, { provider: 'twitter', uid: rand(10000) })
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
      end

      it 'creates new registration with Twitter authentication' do
        visit new_user_registration_path
        click_link 'Sign in with Twitter'
        fill_in 'Email', with: attributes_for(:user)[:email]
        fill_in 'ユーザー名', with: attributes_for(:user)[:name]

        expect {
          click_button 'Sign up'
        }.to change(Authentication, :count).by(1).and change(User, :count).by(1)
        expect(Authentication.first.provider).to eq 'twitter'
      end
    end
  end

  describe 'new_user_session_path' do
    context 'when the user has already signed up with Facebook authentication' do
      before do
        email = attributes_for(:user)[:email]
        OmniAuth.config.add_mock(:facebook, { provider: 'facebook', uid: rand(10000), info: { email: email }})
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

        visit new_user_registration_path
        click_link 'Sign in with Facebook'
        fill_in 'ユーザー名', with: attributes_for(:user)[:name]
        click_button 'Sign up'
        sign_out User.first
      end

      it 'signs in with Facebook authentication' do
        visit new_user_session_path
        click_link 'Sign in with Facebook'

        expect(current_path).to eq root_path
        expect(page).to have_content 'facebook'
      end
    end
  end
end
