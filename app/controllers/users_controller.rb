class UsersController < ApplicationController
  include UserRunners

  def index
    @users = run(Index).first
  end

  def show
    @user, @wikis = run(Show, params[:id])
  end

  def new
    @user = run(New).first
  end

  def create
    run(Create, user_params) do |on|
      on.success { |user|
        redirect_to users_path, notice: "Added user #{user.name}"
      }
      on.failure { |user|
        @user = user
        render :new
      }
    end
  end

  def edit
    @user = run(Edit, params[:id]).first
  end

  def update
    run(Update, params[:id], user_edit_params) do |on|
      on.success { |user|
        redirect_to user, notice: "Updated user #{user.name}"
      }
      on.failure { |user|
        @user = user
        render :new
      }
    end
  end

  def destroy
    run(Destroy, params[:id])
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
