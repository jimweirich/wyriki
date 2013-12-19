class UsersController < ApplicationController
  def index
    @users = User.all_users
  end

  def show
    @user = User.find(params[:id])
    @wikis = Wiki.active_wikis
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "Added user #{@user.name}"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_edit_params)
      redirect_to @user, notice: "Updated user #{@user.name}"
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_edit_params
    params.require(:user).permit(:name, :email)
  end
end
