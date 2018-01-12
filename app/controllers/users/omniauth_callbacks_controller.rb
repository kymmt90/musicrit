class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    auth = Authentication.from_omniauth(auth_hash)

    if user_signed_in?
      conenct_with(auth)
    else
      sign_up_or_login_with(auth)
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def connect_with(auth)
    if auth.update(user: current_user)
      flash[:notice] = "#{auth.provider}のアカウントと連携しました"
    else
      flash[:alert] = '連携に失敗しました'
    end
    redirect_to root_path
  end

  def sign_up_or_login_with(auth)
    if auth.user
      sign_in_and_redirect auth.user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider)
    else
      session['devise.omniauth_data'] = auth_hash
      redirect_to new_user_registration_path
    end
  end
end
