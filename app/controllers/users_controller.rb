class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome! You have signed up successfully."
      redirect_to root_path
    else
      flash.now[:error] = "There was a problem with your registration."
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :address, :province_id)
  end
end
