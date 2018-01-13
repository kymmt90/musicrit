class Users::RegistrationsController < Devise::RegistrationsController
  private

  def clean_up_passwords(user)
    super unless user.authentications.present?
  end
end
