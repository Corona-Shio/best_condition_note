require "test_helper"

class DailyRecordTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @daily_records = @user.daily_records.build(date:      Date.new(2024, 10, 1),
                                               sleep:     3,
                                               meal:      3,
                                               mental:    3,
                                               training:  3,
                                               condition: 3)
  end

  test "should be valid" do
    assert @daily_records.valid?
  end

  test "user id should be present" do
    @daily_records.user_id = nil
    assert_not @daily_records.valid?
  end

  test "date should be present" do
    @daily_records.date = "     "
    assert_not @user.valid?
  end

  test "is not valid with a sleep value less than 1" do
    @daily_records.sleep = 0
    assert_not @daily_records.valid?
  end

  test "is not valid with a sleep value greater than 5" do
    @daily_records.sleep = 6
    assert_not @daily_records.valid?
  end

  test "is not valid with a meal value less than 1" do
    @daily_records.meal = 0
    assert_not @daily_records.valid?
  end

  test "is not valid with a meal value greater than 5" do
    @daily_records.meal = 6
    assert_not @daily_records.valid?
  end

  test "is not valid with a mental value less than 1" do
    @daily_records.mental = 0
    assert_not @daily_records.valid?
  end

  test "is not valid with a mental value greater than 5" do
    @daily_records.mental = 6
    assert_not @daily_records.valid?
  end

  test "is not valid with a training value less than 1" do
    @daily_records.training = 0
    assert_not @daily_records.valid?
  end

  test "is not valid with a training value greater than 5" do
    @daily_records.training = 6
    assert_not @daily_records.valid?
  end

  test "is not valid with a condition value less than 1" do
    @daily_records.condition = 0
    assert_not @daily_records.valid?
  end

  test "is not valid with a condition value greater than 5" do
    @daily_records.condition = 6
    assert_not @daily_records.valid?
  end


end
