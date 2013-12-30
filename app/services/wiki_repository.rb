
class WikiRepository

  # User Methods

  def all_users
    User.all_users
  end

  def new_user(attrs={})
    User.new(attrs)
  end

  def find_user(user_id)
    User.find(user_id)
  end

  def save_user(user)
    user.save
  end

  def update_user(user, attrs)
    user.update_attributes(attrs)
  end

  def destroy_user(user_id)
    User.destroy(user_id)
  end

  # Wiki Methods

  def active_wikis
    Wiki.active_wikis
  end

  def new_wiki(attrs={})
    Wiki.new(attrs)
  end

  def find_wiki(wiki_id)
    Wiki.find(wiki_id)
  end

  def find_named_wiki(wiki_name)
    Wiki.find_by_name(wiki_name)
  end

  def save_wiki(wiki)
    wiki.save
  end

  def update_wiki(wiki, attrs)
    wiki.update_attributes(attrs)
  end

  def destroy_wiki(wiki_id)
    Wiki.destroy(wiki_id)
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
