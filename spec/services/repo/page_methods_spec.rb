require 'spec_helper'

module Repo

  class PageRepo
    include PageMethods
  end

  describe PageMethods do
    Given(:repo) { PageRepo.new }
    Given(:bad_id) { 99999999999999 }

    Given!(:wiki) { Wiki.create!(Attrs.wiki) }
    Given!(:page) { wiki.pages.create!(Attrs.page) }

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
end
