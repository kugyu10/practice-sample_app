require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin)
  end

  test "ログイン失敗のFlashがすぐ消える" do 
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "ログインとログアウトが正常にできる" do
    get login_path
    
    #log_inのテスト
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    
    #log_outのテスト 
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    #多重log_outテスト
    delete logout_path
    
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "Remember meログインテスト" do
    log_in_as(@user, remember_me: '1')
    assert_equal session[:user_id], assigns(:user).id
  end
  
  test "Remember meをオフにしてログイン時、cookiesに保存されない" do
    # 1度ログインしてログアウト
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # Remember me オフにしてログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
