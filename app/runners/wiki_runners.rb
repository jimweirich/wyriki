require_dependency './app/runners/runner'

module WikiRunners
  class Index < Runner
    def run
      success(repo.active_wikis)
    end
  end

  class Show < Runner
    def run(wiki_id)
      success(repo.find_wiki(wiki_id))
    end
  end

  class New < Runner
    def run
      success(repo.new_wiki)
    end
  end

  class Create < Runner
    def run(wiki_params)
      wiki = repo.new_wiki(wiki_params)
      if repo.save_wiki(wiki)
        success(wiki)
      else
        failure(wiki)
      end
    end
  end

  class Edit < Runner
    def run(wiki_id)
      success(repo.find_wiki(wiki_id))
    end
  end

  class Update < Runner
    def run(wiki_id, wiki_attrs)
      wiki = repo.find_wiki(wiki_id)
      if repo.update_wiki(wiki, wiki_attrs)
        success(wiki)
      else
        failure(wiki)
      end
    end
  end

  class Destroy < Runner
    def run(wiki_id)
      wiki = repo.find_wiki(wiki_id)
      repo.destroy_wiki(wiki_id)
      success(wiki.name)
    end
  end
end
