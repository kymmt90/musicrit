class Users::RegistrationsController < Devise::RegistrationsController
  private

  # not clean up passwords when using OAuth authentications because passwords are hidden in the form
  def clean_up_passwords(user)
    super unless user.authentications.present?
  end
end
