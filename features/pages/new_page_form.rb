require './features/pages/page_object'

class NewPageForm < PageObject
  def initialize(app, context, wiki_name)
    super(app, context)
    @wiki_name = wiki_name
  end

  def name=(page_name)
    fill_in("page_name", with: page_name)
  end

  def content=(content)
    fill_in("page_content", with: content)
  end

  def submit
    click_button("Create Page")
  end
end
