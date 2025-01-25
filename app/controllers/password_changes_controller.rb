class PasswordChangesController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(password_params)
      flash[:success] = "パスワードを変更しました"
      redirect_to root_url
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private
  
    def password_params
      params.require(:user).permit(:current_password, :password).tap do |user_params|
        user_params[:password_confirmation] = user_params[:password] if user_params[:password]
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
  
end
