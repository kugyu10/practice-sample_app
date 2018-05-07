require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:admin)
  end
  
  test "should get new" do
    get signup_path 
    assert_response :success
  end
  
  test "ログインしていなければログインページへリダイレクトする" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "ログインしていればindexページが見れる" do
    log_in_as(@user)
    get users_path
    assert_response :success
  end
  
end
