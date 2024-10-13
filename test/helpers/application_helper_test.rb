require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal "Best Condition Book", full_title
    assert_equal "Help | Best Condition Book", full_title("Help")
  end
end
