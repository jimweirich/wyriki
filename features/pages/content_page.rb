require './features/pages/page_object'

class ContentPage < PageObject
  def initialize(app, context, wiki_name, page_name)
    super(app, context)
    @wiki_name = wiki_name
    @page_name = page_name
  end

  def visit
    fail "Need Wiki and Page names if using visit" if @wiki_name.nil? || @page_name.nil?
    context.visit "/#{@wiki_name}/#{@page_name}"
    make_current_page
  end

  def must_have_title(title)
    within("h1#page-title") do
      page.should have_content(title)
    end
  end

end
