require "test_helper"

class DailyRecordsEditTest < ActionDispatch::IntegrationTest

  def setup
    @user      = users(:michael)
    @other_user = users(:archer)
    @one  = daily_records(:one)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_daily_record_path(@one)
    assert_template 'daily_records/edit'
    patch daily_record_path(@one), params: { daily_record: { date: "",
                                                             sleep: 6, meal: 0, mental: 0,
                                                             training: 0, condition: 0 } }
    assert_template 'daily_records/edit'
    assert_select "div.alert", "The form contains 6 errors."
  end
  
  test "successful edit" do
    log_in_as(@user)
    get edit_daily_record_path(@one)
    assert_template 'daily_records/edit'
    date      = Date.new(2024, 11, 1)
    sleep     = 5
    meal      = 5
    mental    = 5
    training  = 5
    condition = 5
    patch daily_record_path(@one), params: { daily_record: { date: date,
                                                             sleep: sleep, meal: meal, mental: mental,
                                                             training: training, condition: condition } }
    assert_not flash.empty?
    assert_redirected_to daily_records_path
    @one.reload
    assert_equal date,      @one.date
    assert_equal sleep,     @one.sleep
    assert_equal meal,      @one.meal
    assert_equal mental,    @one.mental
    assert_equal training,  @one.training
    assert_equal condition, @one.condition
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_daily_record_path(@one)
    assert flash.empty?
    assert_redirected_to daily_records_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    date      = Date.new(2024, 11, 1)
    sleep     = 5
    meal      = 5
    mental    = 5
    training  = 5
    condition = 5
    patch daily_record_path(@one), params: { daily_record: { date: date,
                                                             sleep: sleep, meal: meal, mental: mental,
                                                             training: training, condition: condition } }
    assert flash.empty?
    assert_redirected_to daily_records_path
  end

end
