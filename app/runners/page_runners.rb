module PageRunners
  class Show < Runner
    def run(wiki_id, page_id)
      wiki = Wiki.find(wiki_id)
      page = wiki.pages.find(page_id)
      success(wiki, page)
    end
  end

  class ShowNamed < Runner
    def run(wiki_name, page_name)
      wiki = Wiki.find_by_name(wiki_name)
      page = Page.by_name(wiki_name, page_name)
      if page
        success(wiki, page)
      else
        callback(:page_not_found, wiki)
      end
    end
  end

  class NewNamed < Runner
    def run(wiki_name, page_name)
      wiki = Wiki.find_by_name(wiki_name)
      page = wiki.pages.new(name: page_name)
      success(wiki, page)
    end
  end

  class New < Runner
    def run(wiki_id, page_name)
      wiki = Wiki.find(wiki_id)
      page = wiki.pages.new(name: page_name)
      success(wiki, page)
    end
  end

  class Create < Runner
    def run(wiki_id, page_params)
      wiki = Wiki.find(wiki_id)
      page = wiki.pages.new(page_params)
      if page.save
        success(page)
      else
        failure(wiki, page)
      end
    end
  end

  class Edit < Runner
    def run(wiki_id, page_id)
      wiki = Wiki.find(wiki_id)
      page = wiki.pages.find(page_id)
      success(wiki, page)
    end
  end

  class Update
    def run(wiki_id, page_id)
      @wiki = Wiki.find(wiki_id)
      @page = @wiki.pages.find(page_id)
      if @page.update_attributes(content_params)
        success(wiki, page)
      else
        failure(wiki, page)
      end
    end
  end

  class Destroy
    def run(wiki_id, page_id)
      wiki = Wiki.find(wiki_id)
      page = wiki.pages.find(page_id)
      page.destroy
      success(wiki)
    end
  end
end
