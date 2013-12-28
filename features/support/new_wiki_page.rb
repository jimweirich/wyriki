require './features/support/page_object'

class NewWikiPage < PageObject
  def name=(wiki_name)
    fill_in("wiki_name", with: wiki_name)
  end

  def home_page=(home_page)
    fill_in("wiki_home_page", with: home_page)
  end

  def submit
    click_button("Create Wiki")
  end
end
