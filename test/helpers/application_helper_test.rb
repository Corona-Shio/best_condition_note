require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal "Best Condition Note", full_title
    assert_equal "Help | Best Condition Note", full_title("Help")
  end
end
