require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:admin)
    @other_user = users(:user1)
  end
  
  test "未ログインでeditはログインページにリダイレクトされる" do
    get edit_user_path(@user)
    follow_redirect!
    assert_template 'sessions/new'
  end
  
  test "未ログインでupdateはログインページにリダイレクトされる" do
    patch user_path(@user) ,params: { user: {
      name:  @user.name,
      email: @user.email
    }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "違うユーザーでログイン時、editページは開かない" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "違うユーザーでログイン時、updateは実行しない" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  
  test "user#edit失敗時のテスト" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select 'div.alert', false
    patch user_path(@user), params:{user:
     {name:                  "",
      email:                 "foo@invalid",
      password:              "foo",
      password_confirmation: "bar"
     }}
     
    assert_template 'users/edit'
    assert_select 'div.alert'
  end
   
  test "user#edit成功時のテスト" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
  
  
  test "フレンドリーフォワードのテスト" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test "フレンドリーログインのURLがリセットされる" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)

    delete logout_path
    log_in_as(@other_user)
    assert_redirected_to @other_user  
  end
  
end
