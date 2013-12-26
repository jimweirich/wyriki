require './features/support/page_object'

class ContentPage < PageObject
  def initialize(app, context, wiki_name, page_name)
    super(app, context)
    @wiki_name = wiki_name
    @page_name = page_name
  end

  def visit
    context.visit "/#{@wiki_name}/#{@page_name}"
    make_current_page
  end
end
