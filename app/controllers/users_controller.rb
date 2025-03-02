class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy]
  before_action :correct_user,   only: %i[show edit update]
  before_action :admin_user,     only: %i[index destroy]

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    # reCAPTCHAの検証
    return unless verify_recaptcha_and_handle_error(
      action: 'signup', render_template: 'new')

    @user = User.new(user_params)

    if @user.save && verify_recaptcha(model: @user)
      @user.send_activation_email
      flash[:info] = "メールを確認してアカウントを有効化してください"
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit 
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_profile_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to root_url
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url, status: :see_other
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password).tap do |user_params|
        user_params[:password_confirmation] = user_params[:password] if user_params[:password]
      end
    end

    def user_profile_params
      params.require(:user).permit(:name, :email)
    end

    # beforeフィルタ

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
    
end
