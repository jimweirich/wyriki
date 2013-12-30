
class WikiRepository

  # Wiki Methods

  def find_wiki(wiki_id)
    Wiki.find(wiki_id)
  end

  def find_named_wiki(wiki_name)
    Wiki.find_by_name(wiki_name)
  end

  # Page Methods

  def find_wiki_page(wiki_id, page_id)
    wiki = Wiki.find(wiki_id)
    page = wiki.pages.find(page_id)
  end

  def find_page_on(wiki, page_id)
    wiki.pages.find(page_id)
  end

  def find_named_page(wiki_name, page_name)
    Page.by_name(wiki_name, page_name)
  end

  def new_page_on(wiki, attrs={})
    wiki.pages.new(attrs)
  end

  def save_page(page)
    page.save
  end

  def destroy_page_on(wiki, page_id)
    page = wiki.pages.find(page_id)
    page.destroy
  end
end
