class Users::RegistrationsController < Devise::RegistrationsController
  private

  def clean_up_password(user)
    super unless user.authentications.present?
  end
end
