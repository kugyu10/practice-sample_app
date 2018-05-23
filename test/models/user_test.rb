require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(
      name: 'first_user',
      email: 'first@example.com',
      password: 'password',
      password_confirmation: 'password')
  end
  
  test "should be valid" do
    assert @user.valid?
  end  
  
  test "名前がblankではない" do
    @user.name = "      "
    assert_not @user.valid?
  end
  
  test "emailがblankではない" do
    @user.email = "      "
    assert_not @user.valid?
  end
  
  test "名前が50文字以下" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "emailが255字以下" do
    @user.name = "a" * 244 + '@example.com'
    assert_not @user.valid?
  end
  
  test "emailバリデーションで以下のを通す" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "emailバリデーションで以下は止める" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "emailの一意性確認" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "emailはlower-caseで保存されている" do
    mixed_case_email = "Foo@ExAMPle.CoM" #foo@example.comでDB保存されてほしい
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end 
  
  
  test "passwordはblank不可" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password最低長さが8" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "remember_digestが空でもエラーでない" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "UserをdestroyしたときMicropostもdestroyされる" do
    @user.save
    @user.microposts.create!(content: "Lorem ipum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
   test "他ユーザーをフォロー・アンフォローできる" do
    kugyu10 = users(:admin)
    user_9  = users(:user_9)
    assert_not kugyu10.following?(user_9)
    kugyu10.follow(user_9)
    assert kugyu10.following?(user_9)
    assert user_9.followers.include?(kugyu10)
    kugyu10.unfollow(user_9)
    assert_not kugyu10.following?(user_9)
  end
  
  test "feedが正しい投稿を持っている" do
    kugyu10 = users(:admin)
    archer  = users(:user_2)
    lana    = users(:user_3)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert kugyu10.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    kugyu10.microposts.each do |post_self|
      assert kugyu10.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not kugyu10.feed.include?(post_unfollowed)
    end
  end
end
