
class ShowNamed < Runner
  def do_run(wiki_name, page_name)
    wiki = Wiki.find_by_name(wiki_name)
    page = Page.by_name(wiki_name, page_name)
    if page
      success(wiki, page)
    else
      callback(:page_not_found, wiki)
    end
  end
end
