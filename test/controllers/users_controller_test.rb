require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:admin)
    @other_user = users(:user1)
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
    log_in_as(@admin)
    get users_path
    assert_response :success
  end
  
    test "admin属性をPATCHで触れないこと" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              'password',
                                            password_confirmation: 'password',
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  
    test "ログインしていなければdestroyアクションでリダイレクト" do
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to login_url
  end

  test "管理者でなければdestroyアクションでリダイレクトする" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to root_url
  end
  
    test "管理者ログイン時のuser#indexでdeleteリンクが表示・動作すること" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
  end

  test "index as non-admin" do
    log_in_as(@other_user)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
    test "should redirect following when not logged in" do
    get following_user_path(@other_user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@other_user)
    assert_redirected_to login_url
  end
end
