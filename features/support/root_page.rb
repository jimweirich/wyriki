class RootPage < PageObject
  def visit
    context.visit "/"
    make_current_page
  end

  def create_new_wiki
    click_link("Create new wiki")
  end

  def has_notice(notice_message)
    within(".flash") do
      page.should have_content(text)
    end
  end

  def has_wiki_in_list(wiki_name)
    within("div#wikilist ul > li") do
      page.should have_content(wiki_name)
    end
  end
end
