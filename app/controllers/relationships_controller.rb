class RelationshipsController < ApplicationController

  before_action :logged_in_user

  #current_userがuserをフォローする
  def create
    user = User.find(params[:id])
    current_user.follow(user)
    redirect_to user
  end
  
  #current_userがuserをフォロー解除する
  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    redirect_to user
  end

end
