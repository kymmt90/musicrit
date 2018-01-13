require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'new_user_registration_path' do
    context 'when the user sign up with external service authentications' do
      before do
        Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      end

      context 'when using Facebook' do
        before do
          email = attributes_for(:user)[:email]
          OmniAuth.config.add_mock(:facebook, { provider: 'facebook', uid: rand(10000), info: { email: email }})
          Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
        end

        it 'creates new registration with Facebook authentication' do
          visit new_user_registration_path
          click_link 'Sign in with Facebook'

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

          expect {
            click_button 'Sign up'
          }.to change(Authentication, :count).by(1).and change(User, :count).by(1)
          expect(Authentication.first.provider).to eq 'twitter'
        end
      end
    end
  end
end
