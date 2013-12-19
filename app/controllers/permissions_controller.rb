class PermissionsController < ApplicationController

  def create
    wiki = Wiki.find(permission_params[:wiki_id])
    user = User.find(permission_params[:user_id])
    perm = user.permissions.new(wiki: wiki, role: permission_params[:role])
    if perm.save
      redirect_to user, notice: "Permitting #{user.name} to be a #{perm.role} on #{wiki.name}"
    else
      redirect_to user
    end
  end

  def update
    wiki = Wiki.find(permission_params[:wiki_id])
    user = User.find(permission_params[:user_id])
    perm = user.permission_for(wiki)
    if perm.update_attributes(permission_params)
      redirect_to user, notice: "Permitting #{user.name} to be a #{perm.role} on #{wiki.name}"
    else
      redirect_to user
    end
  end

  private

  def permission_params
    params.require(:permission).permit(:role, :wiki_id, :user_id)
  end
end
