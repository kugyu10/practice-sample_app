class UsersController < ApplicationController

  def index
    @user = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new 
  end
  
  
  # POST /users
  def create
    
    #@user = User.new(params[:user])
    @user = User.new(user_params)
    
    if @user.save
      # 成功
      flash[:success] = "Wellcome to Sample App"
      redirect_to @user # redirect_to user_path(@user.id)の省略形
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
