class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      #成功
      log_in @user
      # Remember meがチェックされていたら
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user
    else
      #失敗
      flash.now[:danger] = 'Invalid email/password combination' 
      render 'new'
    end
  end
  
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
