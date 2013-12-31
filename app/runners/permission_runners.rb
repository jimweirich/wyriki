require_dependency './app/runners/runner'

module PermissionRunners

  class PermissionRunner < Runner
    private

    def notice_message(perm, user, wiki)
      "#{user.name} is now a #{perm.role} on #{wiki.name}"
    end
  end

  class Create < PermissionRunner
    def run(wiki_id, user_id, perm_attrs)
      wiki = repo.find_wiki(wiki_id)
      user = repo.find_user(user_id)
      perm = repo.new_permission(user: user, wiki: wiki, role: perm_attrs)
      if repo.save_permission(perm)
        success(user, notice_message(perm, user, wiki))
      else
        failure(user)
      end
    end
  end

  class Update < PermissionRunner
    def run(wiki_id, user_id, role)
      wiki = repo.find_wiki(wiki_id)
      user = repo.find_user(user_id)
      perm = repo.find_permission_for(wiki, user)
      if repo.update_permission(perm, role: role)
        success(user, notice_message(perm, user, wiki))
      else
        failure(user)
      end
    end
  end

end
