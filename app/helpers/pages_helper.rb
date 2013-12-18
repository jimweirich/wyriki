module PagesHelper
  def named_page_link(page)
    named_page_path(page.wiki.name, page.name)
  end
end
