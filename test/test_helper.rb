require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end

  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user_id
  end
end



# 統合テスト用ヘルパーメソッドをActionDispatch::IntegrationTestに定義する
class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    # 単体テストと違って直接sessionをいじれないので、POSTする
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end