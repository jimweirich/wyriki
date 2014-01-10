require 'spec_helper'

module Repo

  class WikiRepo
    include WikiMethods
  end

  describe WikiMethods do
    Given(:repo) { WikiRepo.new }
    Given(:bad_id) { 99999999999999 }

    Given!(:wiki) { Wiki.create!(Attrs.wiki) }
    Given!(:page) { wiki.pages.create!(Attrs.page) }

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

      Then { saved }
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



  end
end
