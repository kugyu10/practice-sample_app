require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
 
  def setup
    @user = users(:admin)
    @micropost = microposts(:orange)
  end
  
  test "createはログインしていなければリダイレクト" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "destroyはログインしていなければリダイレクト" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  
  test "自分のツイートのみ削除できる" do
    log_in_as(@user)
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end
