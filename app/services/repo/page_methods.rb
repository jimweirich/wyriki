module Repo
  module PageMethods
    def find_wiki_page(wiki_id, page_id)
      wiki = Wiki.find(wiki_id)
      page = wiki.pages.find(page_id)
      Biz::Page.wrap(page)
    end

    def find_page_on(wiki, page_id)
      Biz::Page.wrap(wiki.pages.find(page_id))
    end

    def find_named_page(wiki_name, page_name)
      Biz::Page.wrap(Page.by_name(wiki_name, page_name))
    end

    def new_page_on(wiki, attrs={})
      Biz::Page.wrap(wiki.pages.new(attrs))
    end

    def save_page(page)
      page.data.save
    end

    def destroy_page_on(wiki, page_id)
      page = wiki.pages.find(page_id)
      page.data.destroy
      nil
    end
  end

end
