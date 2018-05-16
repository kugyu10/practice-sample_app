require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:admin).id,
                                     followed_id: users(:user_10).id)
  end

  test "フォロー関係があるか？" do
    assert @relationship.valid?
  end

  test "フォロワーID必須" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "フォローID必須" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
