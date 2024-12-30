require "test_helper"

class DailyRecordsEditTest < ActionDispatch::IntegrationTest

  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
    @one  = daily_records(:one)
  end

  test "successful edit daily_record via turbo frame" do
    log_in_as(@user)

    get daily_records_path
    assert_response :success

    # 編集ページへのTurbo Frame経由のアクセス
    get edit_daily_record_path(@one), 
        headers: { 
          'Accept': 'text/vnd.turbo-stream.html',
          'Turbo-Frame': dom_id(@one)
        }

    # レスポンスの検証
    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html', response.media_type

    assert_select '.row-edit', 1

    # Turbo Streamの内容を検証
    assert_select "turbo-stream[action='replace'][target='#{dom_id(@one)}']"

    sleep = 5
    meal = 5
    mental = 5
    training  = 1
    condition = 1

    patch daily_record_path(@one), params: { daily_record: { sleep: sleep, meal: meal, mental: mental, 
                                                             training: training, condition: condition } },
                                    headers: { 'Accept': 'text/vnd.turbo-stream.html', 'Turbo-Frame': dom_id(@one) }
    
    assert_not flash.empty?

    # レスポンスの検証
    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html', response.media_type

    @one.reload
    assert_equal sleep,      @one.sleep
    assert_equal meal,       @one.meal
    assert_equal mental,     @one.mental
    assert_equal training,   @one.training
    assert_equal condition,  @one.condition

    assert_select '.row-edit', 0
    # oneのdom_idを持つturbo-frameの中にeditリンクがあることを確認
    assert_select "turbo-frame##{dom_id(@one)}" do
    assert_select "a", text: "Edit", 
                      href: edit_daily_record_path(@one),
                      count: 1
    end

  end

  test "edit cancel via turbo frame" do
    log_in_as(@user)

    get daily_records_path
    assert_response :success

    # 編集ページへのTurbo Frame経由のアクセス
    get edit_daily_record_path(@one), 
        headers: { 
          'Accept': 'text/vnd.turbo-stream.html',
          'Turbo-Frame': dom_id(@one)
        }

    # レスポンスの検証
    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html', response.media_type

    assert_select '.row-edit', 1

    # Turbo Streamの内容を検証
    assert_select "turbo-stream[action='replace'][target='#{dom_id(@one)}']"

    # キャンセルリンクの検証
    assert_select "a.btn.btn-warning.cancel[href='#{daily_record_path(@one)}']"

    # キャンセルボタンのシミュレート
    get daily_record_path(@one), 
        headers: { 
          'Accept': 'text/vnd.turbo-stream.html',
          'Turbo-Frame': dom_id(@one)
        }

    # レスポンスの検証
    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html', response.media_type


    assert_select '.row-edit', 0
    
    # oneのdom_idを持つturbo-frameの中にeditリンクがあることを確認
    assert_select "turbo-frame##{dom_id(@one)}" do
      assert_select "a", text: "Edit", 
                        href: edit_daily_record_path(@one),
                        count: 1
    end

  end

end
