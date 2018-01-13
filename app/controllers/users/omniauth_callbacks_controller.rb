class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authentication = Authentication.from_omniauth(auth_hash)

    if user_signed_in?
      conenct_with(authentication)
    else
      sign_up_or_login_with(authentication)
    end
  end
  alias twitter facebook

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def connect_with(authentication)
    if authentication.update(user: current_user)
      flash[:notice] = "#{authentication.provider}のアカウントと連携しました"
    else
      flash[:alert] = '連携に失敗しました'
    end
    redirect_to root_path
  end

  def sign_up_or_login_with(authentication)
    if authentication.user
      sign_in_and_redirect authentication.user, event: :authentication
      set_flash_message(:notice, :success, kind: authentication.provider)
    else
      session['devise.omniauth_data'] = auth_hash
      redirect_to new_user_registration_path
    end
  end
end
