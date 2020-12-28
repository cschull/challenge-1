require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get handle" do
    get reports_handle_url
    assert_response :success
  end

end
