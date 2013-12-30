require './features/pages/page_object'

class MainPage < PageObject
  def initialize(app, context, wiki_name)
    @app = app
    @context = context
    @wiki_name = wiki_name
    @wiki = Wiki.find_by_name(wiki_name)
  end

  def visit
    context.visit "/wikis/#{@wiki.id}"
    make_current_page
  end

  def click_create_page
    click_link("Create page")
  end

  def click_delete_wiki
    click_link("Delete")
  end

end
