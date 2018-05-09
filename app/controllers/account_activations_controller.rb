class AccountActivationsController < ApplicationController

  # 本質的にはupdateだが、メールリンクで実現する都合上、editアクションにしている
  def edit
    user = User.find_by(email: params[:email])
    # userがいて、未アクティペートで、tokenも正しいとき
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
  
end
