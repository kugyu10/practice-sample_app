require 'test_helper' #test対象

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:admin)
    remember(@user)
  end

  test "current_userが正しいユーザーを返す" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "User.digestが異なるとき、current_userはnilを返す" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
