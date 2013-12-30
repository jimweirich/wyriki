require_dependency './app/runners/runner'

module PageRunners

  class Repo
    def find_wiki(wiki_id)
      Wiki.find(wiki_id)
    end
    def find_wiki_page(wiki_id, page_id)
      wiki = Wiki.find(wiki_id)
      page = wiki.pages.find(page_id)
    end
    def find_named_page(wiki_name, page_name)
      Page.by_name(wiki_name, page_name)
    end
    def find_named_wiki(wiki_name)
      Wiki.find_by_name(wiki_name)
    end
    def new_page_on_wiki(wiki, attrs={})
      wiki.pages.new(attrs)
    end
    def find_page_on(wiki, page_id)
      wiki.pages.find(page_id)
    end
    def save_page(page)
      page.save
    end
    def destroy_page_on(wiki, page_id)
      page = wiki.pages.find(page_id)
      page.destroy
    end
  end

  class RunnerWithRepo < Runner
    def repo
      @repo ||= Repo.new
    end
    def with_repo(repo)
      @repo = repo
      self
    end
  end

  class Show < RunnerWithRepo
    def run(wiki_id, page_id)
      page = repo.find_wiki_page(wiki_id, page_id)
      success(page.wiki, page)
    end
  end

  class ShowNamed < RunnerWithRepo
    def run(wiki_name, page_name)
      page = repo.find_named_page(wiki_name, page_name)
      if page
        success(page.wiki, page)
      else
        callback(:page_not_found, wiki_name)
      end
    end
  end

  class NewNamed < RunnerWithRepo
    def run(wiki_name, page_name)
      wiki = repo.find_named_wiki(wiki_name)
      page = repo.new_page_on_wiki(wiki, name: page_name)
      success(wiki, page)
    end
  end

  class New < RunnerWithRepo
    def run(wiki_id, page_name)
      wiki = repo.find_wiki(wiki_id)
      page = repo.new_page_on_wiki(wiki, name: page_name)
      success(page.wiki, page)
    end
  end

  class Create < RunnerWithRepo
    def run(wiki_id, page_params)
      wiki = repo.find_wiki(wiki_id)
      page = repo.new_page_on_wiki(wiki, page_params)
      if repo.save_page(page)
        success(page)
      else
        failure(wiki, page)
      end
    end
  end

  class Edit < RunnerWithRepo
    def run(wiki_id, page_id)
      wiki = repo.find_wiki(wiki_id)
      page = repo.find_page_on(wiki, page_id)
      success(wiki, page)
    end
  end

  class Update < RunnerWithRepo
    def run(wiki_id, page_id, params)
      wiki = repo.find_wiki(wiki_id)
      page = repo.find_page_on(wiki, page_id)
      if repo.update_page(page, params)
        success(wiki, page)
      else
        failure(wiki, page)
      end
    end
  end

  class Destroy < RunnerWithRepo
    def run(wiki_id, page_id)
      wiki = repo.find_wiki(wiki_id)
      page = repo.destroy_page_on(wiki, page_id)
      success(wiki)
    end
  end
end
