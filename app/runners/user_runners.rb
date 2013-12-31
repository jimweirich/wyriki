require_dependency './app/runners/runner'

module UserRunners

  class Index < Runner
    def run
      success(repo.all_users)
    end
  end

  class Show < Runner
    def run(user_id)
      success(repo.find_user(user_id), repo.active_wikis)
    end
  end

   class New < Runner
    def run
      success(repo.new_user)
    end
  end

  class Create < Runner
    def run(user_params)
      user = repo.new_user(user_params)
      if repo.save_user(user)
         success(user)
      else
        failure(user)
      end
    end
  end

  class Edit < Runner
    def run(user_id)
      success(repo.find_user(user_id))
    end
  end

  class Update < Runner
    def run(user_id, attrs)
      user = repo.find_user(user_id)
      if repo.update_user(user, attrs)
        success(user)
      else
        failure(user)
      end
    end
  end


  class Destroy < Runner
    def run(user_id)
      repo.destroy_user(user_id)
      success
    end
  end
end
