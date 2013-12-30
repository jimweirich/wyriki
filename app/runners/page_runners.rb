require_dependency './app/runners/runner'

module PageRunners

  class Show < Runner
    def run(wiki_id, page_id)
      page = repo.find_wiki_page(wiki_id, page_id)
      success(page.wiki, page)
    end
  end

  class ShowNamed < Runner
    def run(wiki_name, page_name)
      page = repo.find_named_page(wiki_name, page_name)
      if page
        success(page.wiki, page)
      else
        callback(:page_not_found, wiki_name)
      end
    end
  end

  class NewNamed < Runner
    def run(wiki_name, page_name)
      wiki = repo.find_named_wiki(wiki_name)
      page = repo.new_page_on(wiki, name: page_name)
      success(wiki, page)
    end
  end

  class New < Runner
    def run(wiki_id, page_name)
      wiki = repo.find_wiki(wiki_id)
      page = repo.new_page_on(wiki, name: page_name)
      success(page.wiki, page)
    end
  end

  class Create < Runner
    def run(wiki_id, page_params)
      wiki = repo.find_wiki(wiki_id)
      page = repo.new_page_on(wiki, page_params)
      if repo.save_page(page)
        success(page)
      else
        failure(wiki, page)
      end
    end
  end

  class Edit < Runner
    def run(wiki_id, page_id)
      wiki = repo.find_wiki(wiki_id)
      page = repo.find_page_on(wiki, page_id)
      success(wiki, page)
    end
  end

  class Update < Runner
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

  class Destroy < Runner
    def run(wiki_id, page_id)
      wiki = repo.find_wiki(wiki_id)
      page = repo.destroy_page_on(wiki, page_id)
      success(wiki)
    end
  end
end
