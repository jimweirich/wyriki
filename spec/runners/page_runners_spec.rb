require 'fast_helper'
require 'app/runners/page_runners'

module PageRunners
  describe PageRunners do
    Given(:context) { double(repo: repo) }
    Given(:wiki) { double(id: 123, name: "Base") }
    Given(:page) { double(id: 124, wiki: wiki, name: "HomePage") }
    Given(:callback) { FauxCallback.new }
    Given(:cb_config) { callback.configure(:page_not_found) }

    Given(:runner) {
      runner_under_test.new(context, &cb_config)
    }

    describe Show do
      Given(:repo) { double(find_wiki_page: page) }
      Given(:runner_under_test) { Show }

      When { runner.run(wiki.id, page.id) }

      Then { repo.should have_received(:find_wiki_page).with(wiki.id, page.id) }
      Then { callback.invoked == [:success, wiki, page] }
    end

    describe ShowNamed do
      Given(:runner_under_test) { ShowNamed }

      When { runner.run(wiki.name, page.name) }

      context "when page is found" do
        Given(:repo) { double(find_named_page: page) }
        Then { repo.should have_received(:find_named_page).with(wiki.name, page.name) }
        Then { callback.invoked == [:success, wiki, page] }
      end

      context "when page is not found" do
        Given(:repo) { double(find_named_page: nil) }
        Then { repo.should have_received(:find_named_page).with(wiki.name, page.name) }
        Then { callback.invoked == [:page_not_found, wiki.name] }
      end
    end

    describe NewNamed do
      Given(:runner_under_test) { NewNamed }
      Given(:repo) {
        double(find_named_wiki: wiki, new_page_on: page)
      }

      When { runner.run(wiki.name, page.name) }

      Then { repo.should have_received(:find_named_wiki).with(wiki.name) }
      Then { repo.should have_received(:new_page_on).with(wiki, name: page.name) }
      Then { callback.invoked == [:success, wiki, page] }
    end

    describe New do
      Given(:runner_under_test) { New }
      Given(:repo) {
        double(find_wiki: wiki, new_page_on: page)
      }

      When { runner.run(wiki.id, page.name) }

      Then { repo.should have_received(:find_wiki).with(wiki.id) }
      Then { repo.should have_received(:new_page_on).with(wiki, name: page.name) }
      Then { callback.invoked == [:success, wiki, page] }
    end

    describe Create do
      Given(:page_attrs) { { name: "HomePage" } }
      Given(:runner_under_test) { Create }
      Given(:repo) {
        double(find_wiki: wiki, new_page_on: page)
      }

      When { runner.run(wiki.id, page_attrs) }

      Invariant { repo.should have_received(:find_wiki).with(wiki.id) }
      Invariant { repo.should have_received(:new_page_on).with(wiki, page_attrs) }
      Invariant { repo.should have_received(:save_page).with(page) }

      context "with no errors" do
        Given { repo.stub(save_page: true) }
        Then { callback.invoked == [:success, page] }
      end

      context "with errors" do
        Given { repo.stub(save_page: false) }
        Then { callback.invoked == [:failure, wiki, page] }
      end
    end

    describe Edit do
      Given(:runner_under_test) { Edit }
      Given(:repo) {
        double(find_wiki: wiki, find_page_on: page)
      }

      When { runner.run(wiki.id, page.id) }

      Then { repo.should have_received(:find_wiki).with(wiki.id) }
      Then { repo.should have_received(:find_page_on).with(wiki, page.id) }
      Then { callback.invoked == [:success, wiki, page] }
    end

    describe Update do
      Given(:page_attrs) { { content: "CONTENT" } }
      Given(:runner_under_test) { Update }
      Given(:repo) {
        double(find_wiki: wiki, find_page_on: page)
      }

      When { runner.run(wiki.id, page.id, page_attrs) }

      Invariant { repo.should have_received(:find_wiki).with(wiki.id) }
      Invariant { repo.should have_received(:find_page_on).with(wiki, page.id) }
      Invariant { repo.should have_received(:update_page).with(page, page_attrs) }

      context "with no errors" do
        Given { repo.stub(update_page: true) }
        Then { callback.invoked == [:success, wiki, page] }
      end

      context "with errors" do
        Given { repo.stub(update_page: false) }
        Then { callback.invoked == [:failure, wiki, page] }
      end
    end

    describe Destroy do
      Given(:runner_under_test) { Destroy }
      Given(:repo) {
        double(find_wiki: wiki, destroy_page_on: true )
      }

      When { runner.run(wiki.id, page.id) }

      Then { repo.should have_received(:find_wiki).with(wiki.id) }
      Then { repo.should have_received(:destroy_page_on).with(wiki, page.id) }
      Then { callback.invoked == [:success, wiki] }
    end
  end
end
