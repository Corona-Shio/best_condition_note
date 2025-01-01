require "test_helper"

class DailyRecordIndex < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @one  = daily_records(:one)
    @new_date = Date.today.beginning_of_month + 1
    log_in_as(@user)
    get daily_records_path
  end
end

class TurboEditLinkTest < DailyRecordIndex

  test "turbo edit link" do
    assert_select "turbo-frame##{dom_id(@one)}" do
      assert_select "form", count: 0
    end

    assert_select '.row-edit', 0
    assert_select "turbo-frame##{dom_id(@one)}" do
      assert_select "a", text: 'Edit', count: 1
    end

    # 編集ページへのTurbo Frame経由のアクセス
    get edit_daily_record_path(@one), headers: { 'Turbo-Frame': dom_id(@one)}

    assert_response :success
    assert_select '.row-edit', 1
    assert_select "turbo-frame##{dom_id(@one)}" do
      assert_select "form", count: 1
    end
  end

end

class DailyRecordsIndexEditBase < DailyRecordIndex
  def setup
    super
    get edit_daily_record_path(@one), headers: { 'Turbo-Frame': dom_id(@one)}
  end
end

class DailyRecordsIndexEditTest < DailyRecordsIndexEditBase

  test "successful edit daily_record via turbo frame" do
    sleep     = 5
    meal      = 4
    mental    = 3
    training  = 2
    condition = 1

    patch daily_record_path(@one), params: { daily_record: { sleep: sleep, meal: meal, mental: mental, 
                                                             training: training, condition: condition } },
                                   headers: { 'Accept': 'text/vnd.turbo-stream.html', 'Turbo-Frame': dom_id(@one) }
    
    assert_not flash.empty?

    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html', response.media_type

    @one.reload
    assert_equal sleep,     @one.sleep
    assert_equal meal,      @one.meal
    assert_equal mental,    @one.mental
    assert_equal training,  @one.training
    assert_equal condition, @one.condition

    assert_select '.row-edit', 0
    assert_select "turbo-frame##{dom_id(@one)}" do
      assert_select "a", text: 'Edit', count: 1
    end
  end

  test "edit cancel via turbo frame" do
    # キャンセルボタンのシミュレート
    get daily_record_path(@one), headers: { 'Turbo-Frame': dom_id(@one)}

    assert_response :success

    assert_select '.row-edit', 0
    assert_select "turbo-frame##{dom_id(@one)}" do
      assert_select "a", text: 'Edit', count: 1
    end
  end

  test "unsuccessful edit daily_record via turbo frame" do
    patch daily_record_path(@one), params: { daily_record: { sleep: 5, meal: 5, mental: 5, 
                                                           training: 1, condition: "" } },
                                   headers: { 'Accept': 'text/vnd.turbo-stream.html', 'Turbo-Frame': dom_id(@one) }
    
    assert_response :unprocessable_entity
    assert_equal 'text/vnd.turbo-stream.html', response.media_type

    assert_select '.row-edit', count: 1
    assert_select "turbo-frame##{dom_id(@one)}" do
      assert_select "form", count: 1
    end
  end

end

class TurboNewLinkTest < DailyRecordIndex

  test "turbo new link" do
    assert_select '.row-edit', 0
    assert_select "turbo-frame#record_#{@new_date}" do
      assert_select "a", text: 'New', count: 1
    end

    # 編集ページへのTurbo Frame経由のアクセス
    get new_daily_record_path(date: @new_date), headers: { 'Turbo-Frame': "record_#{@new_date}" }

    # 共通の検証
    assert_response :success
    assert_select '.row-edit', 1
    assert_select "turbo-frame#record_#{@new_date}" do
      assert_select "form", count: 1
    end
  end

end

class DailyRecordsIndexNewBase < DailyRecordIndex
  def setup
    super
    get new_daily_record_path(date: @new_date), headers: { 'Turbo-Frame': "record_#{@new_date}" }
  end
end

class DailyRecordsIndexNewTest < DailyRecordsIndexNewBase
  
  test "successful create daily_record via turbo frame" do

    sleep     = 5
    meal      = 4
    mental    = 3
    training  = 2
    condition = 1

    post daily_records_path, params: { daily_record: { date: @new_date, sleep: sleep, meal: meal, mental: mental, 
                                                       training: training, condition: condition } },
                             headers: { 'Accept': 'text/vnd.turbo-stream.html', 'Turbo-Frame': "record_#{@new_date}" }

    assert_not flash.empty?

    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html', response.media_type

    @new_record = @user.daily_records.find_by(date: @new_date)
    
    assert_not @new_record.nil?
    assert_equal sleep,     @new_record.sleep
    assert_equal meal,      @new_record.meal
    assert_equal mental,    @new_record.mental
    assert_equal training,  @new_record.training
    assert_equal condition, @new_record.condition

    assert_select '.row-edit', 0
    assert_select "turbo-frame##{dom_id(@new_record)}" do
      assert_select "a", text: 'Edit', count: 1
    end

  end

  test "create cancel via turbo frame" do
    
    get empty_daily_records_path(date: @new_date), headers: { 'Turbo-Frame': "record_#{@new_date}"}

    assert_response :success

    assert_select '.row-edit', 0
    assert_select "turbo-frame#record_#{@new_date}" do
      assert_select "a", text: 'New', count: 1
    end

  end

  test "unsuccessful create via turbo frame" do

    post daily_records_path, params: { daily_record: { date: @new_date, sleep: 5, meal: 5, mental: 5, 
                                                       training: 1, condition: "" } },
                             headers: { 'Accept': 'text/vnd.turbo-stream.html', 'Turbo-Frame': "record_#{@new_date}" }
    
    assert_response :unprocessable_entity
    assert_equal 'text/vnd.turbo-stream.html', response.media_type

    assert_select '.row-edit', 1
    assert_select "turbo-frame#record_#{@new_date}" do
      assert_select "form", count: 1
    end

  end

end
