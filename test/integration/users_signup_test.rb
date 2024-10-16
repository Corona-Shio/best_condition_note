require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'

    # ———必要性がどの程度あるのかわかっていない—————————————
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'

    # エラーメッセージ内容の確認
    assert_select 'div#error_explanation ul' do
      assert_select 'li', "Name can't be blank"
      assert_select 'li', "Email is invalid"
      assert_select 'li', "Password confirmation doesn't match Password"
      assert_select 'li', "Password is too short (minimum is 6 characters)"
      # 他の必要なエラーメッセージもここに追加します
    end
    # ————————————————————————————————————————————————
    
  end

  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
  end
  
end
