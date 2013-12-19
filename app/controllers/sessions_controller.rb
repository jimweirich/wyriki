class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to wikis_path
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to wikis_path
  end
end
