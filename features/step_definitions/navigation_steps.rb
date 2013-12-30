
Given(/^I am an admin$/) do
#  pending # express the regexp above with the code you wish you had
end

Given(/^I am on the "(.*?)" page$/) do |page_name|
  app.root_page.visit
end

Given(/^I create a new wiki named "(.*?)" with "(.*?)"$/) do |wiki_name, home_page|
  app.root_page.create_new_wiki
  form = app.new_wiki_form
  form.name = wiki_name
  form.home_page = home_page
  form.submit
end

Given(/^I click "(.*?)"$/) do |link|
  app.root_page.create_new_wiki
end

Given(/^I press "(.*?)"$/) do |button|
  click_button(button)
end

Given(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in(("wiki_" + field.gsub(/ /, '_')).downcase, with: value)
end

Then(/^page should have notice message "(.*?)"$/) do |notice_message|
  app.root_page.has_notice(notice_message)
end

Then(/^page should have "(.*?)" in the list of wikis$/) do |wiki_name|
  app.root_page.has_wiki_in_list(wiki_name)
end

Then(/^page should not have "(.*?)" in the list of wikis$/) do |wiki_name|
  app.root_page.has_wiki_in_list(wiki_name, have: false)
end

Given(/^a base wiki$/) do
  wiki = Wiki.create!(Attrs.wiki(name: "Base"))
  pg = wiki.pages.create!(Attrs.page(name: "HomePage", content: "goto AnotherPage"))
  writer = User.create!(Attrs.user(name: "writer", email: "writer@writer"))
  writer.permissions.create!(wiki: wiki, role: "writer")
  reader = User.create!(Attrs.user(name: "reader", email: "reader@reader"))
  reader.permissions.create!(wiki: wiki, role: "reader")
end

Given(/^noone is logged in$/) do
  page = app.root_page
  page.visit
  page.signout
end

Given(/^I am a reader$/) do
  login_page = app.login_page
  login_page.login("reader@reader", "secret")
end

Given(/^I am a writer$/) do
  login_page = app.login_page
  login_page.login("writer@writer", "secret")
end

Given(/^I am on the home page of "(.*?)"$/) do |wiki_name|
  wiki = Wiki.find_by_name(wiki_name)
  content_page = app.content_page(wiki.name, wiki.home_page)
  content_page.visit
end

When(/^I click on an undefined page$/) do
  click_link("?")
end

Then(/^I am taken to the create new page$/) do
  within("h1#pagetitle") do
    page.should have_content("Create Page")
  end
end

Then(/^there is no option to create a new page$/) do
  within("div#page-content") do
    page.should_not have_content("?")
  end
end

Given(/^I am on the main page of "(.*?)"$/) do |wiki_name|
  page = app.main_page(wiki_name)
  page.visit
end

When(/^I create a new page$/) do
  app.current_page.click_create_page
  form = app.new_page_form("Base")
  form.name = "AnotherNewPage"
  form.content = "More Content"
  form.submit
end

Then(/^I can see the new page$/) do
  page = app.content_page
  page.must_have_title("AnotherNewPage")
end

When(/^I delete a wiki named "(.*?)"$/) do |wiki_name|
  click_link(wiki_name)
  main_page = app.main_page(wiki_name)
  main_page.click_delete_wiki
end
