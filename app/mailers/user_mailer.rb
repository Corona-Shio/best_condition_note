class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: email_address_with_name(@user.email, @user.name),
         subject: "アカウントの有効化"
  end

  def password_reset(user)
    @user = user
    mail to: email_address_with_name(@user.email, @user.name),
         subject: "パスワードの再設定"
  end
  
end
