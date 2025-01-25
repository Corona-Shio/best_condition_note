require "test_helper"

class PasswordChangesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect edit when not logged in" do
    get edit_password_change_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch password_change_path(@other_user), params: { user: { password: "password",
                                                               admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_password_change_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch password_change_path(@user), params: { user: { password: "password" } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in user" do
    log_in_as(@user)
    patch password_change_path(@user), params: { user: { password: "password" } }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

end
