require './features/pages/page_object'

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

  def has_wiki_in_list(wiki_name, have: true)
    within("div#wikilist ul > li") do
      if have
        page.should have_content(wiki_name)
      else
        page.should_not have_content(wiki_name)
      end
    end
  end

  def signout
    within("div.header p.actions") do
      click_link ("sign out")
    end
  rescue Capybara::ElementNotFound
    # Not currently logged in
  end
end
