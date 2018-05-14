require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:admin)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
  
    test "Micropostが有効" do
    assert @micropost.valid?
  end

  test "ユーザーが必須" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "中身が必須" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "中身が140文字以下" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "最新のMicropostがデフォルトで最初に来る" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
