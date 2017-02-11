require 'test_helper'

class CheckControllerTest < ActionDispatch::IntegrationTest
  test "should get switch" do
    get check_switch_url
    assert_response :success
  end

end
