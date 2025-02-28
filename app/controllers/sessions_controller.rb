class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    # reCAPTCHA検証
    unless verify_recaptcha(action: 'login', minimum_score: 0.5)
      Rails.logger.error "WARNING: illegal contact form request from \"#{request.remote_ip}\""
      flash[:danger] = "reCAPTCHAをクリアしてください"
      render 'new', status: :unprocessable_entity
      return
    end

    if user&.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || root_url
      else
        message  = "アカウント有効化が完了していません"
        message += "メールを確認してアカウントを有効化してください"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが違います'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

end
