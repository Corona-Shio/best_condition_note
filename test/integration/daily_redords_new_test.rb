require "test_helper"

class DailyRedordsNewTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "valid new_daily_record information" do
    log_in_as(@user)
    get new_daily_record_path
    assert_template 'daily_records/new'
    assert_difference 'DailyRecord.count', 1 do
      post daily_records_path, params: { daily_record: { date: Date.new(2024, 11, 1),
                                                                sleep: 3, meal: 3, mental: 3,
                                                                training: 3, condition: 3 } }
    end
    follow_redirect!
    assert_template root_path
    assert_not flash.empty?
  end

  test "invalid new_daily_record information" do
    log_in_as(@user)
    get new_daily_record_path
    assert_template 'daily_records/new'
    assert_no_difference 'DailyRecord.count' do
      post daily_records_path, params: { daily_record: { date: "",
                                                         sleep: 0, meal: 6, mental: "",
                                                         training: "", condition: "" } }
    end
    assert_response :unprocessable_entity
    assert_template 'daily_records/new'

        # ———必要性がどの程度あるのかわかっていない—————————————
        assert_select 'div#error_explanation'
        assert_select 'div.field_with_errors'
    
        # エラーメッセージ内容の確認
        assert_select 'div#error_explanation ul' do
          assert_select 'li', "Dateを入力してください"
          # assert_select 'li', "Condition can't be blank"
          # 他の必要なエラーメッセージもここに追加します
        end
  end

end