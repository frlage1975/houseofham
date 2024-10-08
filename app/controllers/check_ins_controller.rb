class CheckInsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role_id = 1 # Automatically assign role_id = 1 (Customer)
    if @user.save
      redirect_to root_path, notice: 'You have successfully registered.'
    else
      flash.now[:error] = 'There was an error with your registration. Please check the form and try again.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :province_id, :password)
  end
end
