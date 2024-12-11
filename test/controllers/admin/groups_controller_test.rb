require "test_helper"

class Admin::GroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_groups_index_url
    assert_response :success
  end
end
