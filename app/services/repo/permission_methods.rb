module Repo
  module PermissionMethods
    def new_permission(wiki, user, role)
      Biz::Permission.wrap(user.permissions.new(wiki: wiki, role: role))
    end

    def save_permission(perm)
      perm.data.save
    end

    def find_permission_for(wiki, user)
      Biz::Permission.wrap(user.permission_for(wiki))
    end

    def update_permission(perm, attrs)
      perm.data.update_attributes(attrs)
    end
  end
end
