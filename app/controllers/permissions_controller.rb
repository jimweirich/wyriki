class PermissionsController < ApplicationController
  include PermissionRunners

  def create
    wiki_id = permission_params[:wiki_id]
    user_id = permission_params[:user_id]
    role    = permission_params[:role]

    run(Create, wiki_id, user_id, role) do |on|
      on.success { |user, message|
        redirect_to user, notice: message
      }
      on.failure { |user|
        redirect_to user
      }
    end
  end

  def update
    wiki_id = permission_params[:wiki_id]
    user_id = permission_params[:user_id]
    role    = permission_params[:role]

    run(Update, wiki_id, user_id, role) do |on|
      on.success { |user, message|
        redirect_to user, notice: message
      }
      on.failure { |user|
        redirect_to user
      }
    end
  end

  private

  def permission_params
    params.require(:permission).permit(:role, :wiki_id, :user_id)
  end
end
