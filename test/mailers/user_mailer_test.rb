require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "アクティベーションメールのテスト" do
    user = users(:admin)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "アカウント有効化_SampleApp", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  test "パスワードリセットのテスト" do
    user = users(:admin)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "パスワード再設定_SampleApp", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

end
