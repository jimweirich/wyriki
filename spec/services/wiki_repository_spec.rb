require 'spec_helper'

describe WikiRepository do
  Given(:bad_id) { 999999999999999 }
  Given(:repo) { WikiRepository.new }

  Given!(:wiki) { Wiki.create!(Attrs.wiki) }
  Given!(:page) { wiki.pages.create!(Attrs.page) }

  describe "#all_users" do
    Given!(:user1) { User.create(Attrs.user(email: "a@a")) }
    Given!(:user2) { User.create(Attrs.user(email: "b@b")) }
    Then { repo.all_users == [user1, user2] }
  end

  describe "#find_user" do
    Given!(:user) { User.create!(Attrs.user) }
    Then { repo.find_user(user.id) == user }
  end

  describe "#new_user" do
    context "without attributes" do
      When(:new_user) { repo.new_user }
      Then { new_user.new_record? }
    end

    context "with attributes" do
      Given(:attrs) { Attrs.user }
      When(:new_user) { repo.new_user(attrs) }
      Then { new_user.new_record? }
      Then { new_user.name == attrs[:name] }
    end
  end

  describe "#save_user" do
    Given(:new_user) { repo.new_user(Attrs.user(email: "x@x")) }

    When(:saved) { repo.save_user(new_user) }

    Then { saved == true }
    Then { repo.find_user(new_user.id).email == "x@x" }

    context "with bad attributes" do
      Given(:new_user) { repo.new_user(Attrs.user(email: "")) }
      Then { saved == false }
      Then { expect { repo.find_user(new_user.id) }.to raise_error }
    end
  end

  describe "#update_user" do
    Given(:user) { repo.new_user(Attrs.user(name: "OLDNAME")) }
    Given { repo.save_user(user) }
    Given(:attrs) { Attrs.user(name: "NEWNAME") }

    When(:saved) { repo.update_user(user, attrs) }

    Then { saved == true }
    Then { repo.find_user(user.id).name == "NEWNAME" }

    context "with bad attributes" do
      Given(:attrs) { Attrs.user(email: "") }
      Then { saved == false }
      Then { repo.find_user(user.id).name == "OLDNAME" }
    end
  end

  describe "#destroy_user" do
    Given(:user) { repo.new_user(Attrs.user) }
    Given { repo.save_user(user) }
    When { repo.destroy_user(user.id) }
    Then { expect { repo.find_user(user.id) }.to raise_error }
  end

  describe "#active_wikis" do
    Given!(:wiki2) { Wiki.create!(Attrs.wiki(name: "Anotherwiki")) }
    When(:result) { repo.active_wikis }
    Then { result.map { |w| w.name } == [wiki2.name, wiki.name] }
  end

  describe "#new_wiki" do
    describe "with no attrs" do
      When(:new_wiki) { repo.new_wiki }
      Then { new_wiki.new_record? }
      Then { new_wiki.name.nil? }
    end

    describe "with attrs" do
      When(:new_wiki) { repo.new_wiki(Attrs.wiki) }
      Then { new_wiki.new_record? }
      Then { new_wiki.name == Attrs.wiki[:name] }
    end
  end

  describe "#find_wiki" do
    Then { repo.find_wiki(wiki.id) == wiki }

    context "with bad wiki id" do
      When(:result) { repo.find_wiki(bad_id) }
      Then { result.should have_failed(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#find_named_wiki" do
    Then { repo.find_named_wiki(wiki.name) == wiki }
    Then { repo.find_named_wiki("UNKNOWN").nil? }
  end

  describe "#find_wiki_page" do
    Then { repo.find_wiki_page(wiki.id, page.id) == page }

    context "with bad page id" do
      When(:result) { repo.find_wiki_page(wiki.id, bad_id) }
      Then { result.should have_failed(ActiveRecord::RecordNotFound) }
    end

    context "with bad wiki id" do
      When(:result) { repo.find_wiki_page(bad_id, page.id).nil? }
      Then { result.should have_failed(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#save_wiki" do
    Given(:wiki_name) { "Newwiki" }
    Given(:new_wiki) { repo.new_wiki(Attrs.wiki(name: wiki_name)) }

    When(:saved) { repo.save_wiki(new_wiki) }

    Then { saved }
    Then { repo.find_named_wiki(wiki_name) == new_wiki }

    context "with bad attributes" do
      Given(:wiki_name) { "" }
      Then { ! saved }
      Then { repo.find_named_wiki(wiki_name).nil? }
    end
  end

  describe "#update_wiki" do
    Given(:new_name) { "Newwikiname" }
    Given(:attrs) { Attrs.wiki(name: new_name) }

    When(:saved) { repo.update_wiki(wiki, attrs) }

    Then { saved == true }
    Then { repo.find_wiki(wiki.id).name == new_name }

    context "with bad data" do
      Given!(:old_name) { wiki.name }
      Given(:new_name) { "" }
      Then { ! saved }
      Then { repo.find_wiki(wiki.id).name == old_name }
    end
  end

  describe "#destroy_wiki" do
    Given!(:wiki_name) { wiki.name }
    When { repo.destroy_wiki(wiki.id) }
    Then { repo.find_named_wiki(wiki_name).nil? }
  end

  describe "#find_page_on" do
    Then { repo.find_page_on(wiki, page.id) == page }

    context "with bad page id" do
      When(:result) { repo.find_page_on(wiki, bad_id) }
      Then { result.should have_failed(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#find_named_page" do
    Then { repo.find_named_page(wiki.name, page.name) == page }
    Then { repo.find_named_page(wiki.name, "UNKNOWN").nil? }
    Then { repo.find_named_page("UNKNOWN", page.name).nil? }
  end

  describe "#new_page_on" do
    When(:page) { repo.new_page_on(wiki, name: "NewPage") }
    Then { page.name == "NewPage" }
    Then { page.valid? }
    Then { page.new_record? }
  end

  describe "#save_page" do
    Given(:page) { repo.new_page_on(wiki, name: "NewPage") }

    When(:saved) { repo.save_page(page) }

    Then { saved }
    Then { page.name == "NewPage" }
    Then { ! page.new_record? }

    describe "with bad data" do
      Given(:page) { repo.new_page_on(wiki, name: "Bad Page") }
      Then { ! saved }
    end

  end

  describe "#destroy_page" do
    Given!(:page_name) { page.name }
    Given(:page_id) { page.id }
    When(:result) { repo.destroy_page_on(wiki, page.id) }
    Then { repo.find_named_page(wiki.name, page_name).nil? }

    describe "with bad page id" do
      Given(:page_id) { bad_id }
      Then { result.should_not have_failed }
    end
  end
end
