
class WikiRepository

  # User Methods

  def all_users
    Biz::User.wraps(User.all_users)
  end

  def new_user(attrs={})
    Biz::User.wrap(User.new(attrs))
  end

  def find_user(user_id)
    Biz::User.wrap(User.find(user_id))
  end

  def save_user(user)
    user.data.save
  end

  def update_user(user, attrs)
    user.data.update_attributes(attrs)
  end

  def destroy_user(user_id)
    User.destroy(user_id)
  end

  # Wiki Methods

  def active_wikis
    Biz::Wiki.wraps(Wiki.active_wikis)
  end

  def new_wiki(attrs={})
    Biz::Wiki.wrap(Wiki.new(attrs))
  end

  def find_wiki(wiki_id)
    Biz::Wiki.wrap(Wiki.find(wiki_id))
  end

  def find_named_wiki(wiki_name)
    Biz::Wiki.wrap(Wiki.find_by_name(wiki_name))
  end

  def save_wiki(wiki)
    wiki.data.save
  end

  def update_wiki(wiki, attrs)
    wiki.data.update_attributes(attrs)
  end

  def destroy_wiki(wiki_id)
    Wiki.destroy(wiki_id)
  end

  # Page Methods

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

  # Permission methods

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
