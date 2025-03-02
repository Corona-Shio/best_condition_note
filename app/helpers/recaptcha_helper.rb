module RecaptchaHelper
  def verify_recaptcha_and_handle_error(action:, render_template:, minimum_score: 0.5)
    unless verify_recaptcha(action: action, minimum_score: minimum_score)
      Rails.logger.error "WARNING: illegal reCAPTCHA request from \"#{request.remote_ip}\""
      message  = "Botだと判断されました。もう一度やり直してください。"
      message += "上手くいかない場合は、お手数ですが管理者にお問い合わせください"
      flash[:danger] = message
      render render_template, status: :unprocessable_entity
      return false
    end
    true
  end
end