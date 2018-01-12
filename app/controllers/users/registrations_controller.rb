class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      session.delete('devise.omniauth_data') if user.persisted?
    end
  end

  private

  def clean_up_password(user)
    super unless user.authentications.present?
  end
end
