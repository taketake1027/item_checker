require "test_helper"

class Admin::GroupUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get admin_group_users_destroy_url
    assert_response :success
  end
end
