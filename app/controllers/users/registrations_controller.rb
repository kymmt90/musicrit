class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    if params[:password].present?
      resource.update_without_current_password(params)
    else
      resource.update_without_password(params)
    end
  end

  private

  # not clean up passwords when using OAuth authentications because passwords are hidden in the form
  def clean_up_passwords(user)
    super unless user.authentications.present?
  end
end
