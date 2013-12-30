require 'fast_helper'
require 'app/runners/wiki_runners'

module WikiRunners
  describe WikiRunners do
    Given(:context) { double(repo: repo) }
    Given(:wiki) { double(id: 123, name: "Base") }
    Given(:callback) { FauxCallback.new }
    Given(:cb_config) { callback.configure }

    Given(:runner) {
      runner_under_test.new(context, &cb_config)
    }

    describe Index do
      Given(:runner_under_test) { Index }
      Given(:repo) { double(active_wikis: [:w1, :w2]) }
      When { runner.run }
      Then { repo.should have_received(:active_wikis).with() }
      Then { callback.invoked == [:success, [:w1, :w2]] }
    end

    describe Show do
      Given(:runner_under_test) { Show }
      Given(:repo) { double(find_wiki: :w1) }
      When { runner.run(wiki.id) }
      Then { repo.should have_received(:find_wiki).with(wiki.id) }
      Then { callback.invoked == [:success, :w1] }
    end

    describe New do
      Given(:runner_under_test) { New }
      Given(:repo) { double(new_wiki: :wiki) }
      When { runner.run }
      Then { repo.should have_received(:new_wiki).with() }
      Then { callback.invoked == [:success, :wiki] }
    end

    describe Create do
      Given(:runner_under_test) { Create }
      Given(:repo) { double(new_wiki: wiki, save_wiki: save_result) }
      Given(:save_result) { true }

      When { runner.run(Attrs.wiki) }

      Then { callback.invoked == [:success, wiki] }
      Invariant { repo.should have_received(:new_wiki).with(Attrs.wiki) }
      Invariant { repo.should have_received(:save_wiki).with(wiki) }

      context "with invalid attributes" do
        Given(:save_result) { false }
        Then { callback.invoked == [:failure, wiki] }
      end
    end

    describe Edit do
      Given(:runner_under_test) { Edit }
      Given(:repo) { double(find_wiki: :wiki) }
      When { runner.run(wiki.id) }
      Then { repo.should have_received(:find_wiki).with(wiki.id) }
      Then { callback.invoked == [:success, :wiki] }
    end

    describe Update do
      Given(:runner_under_test) { Update }
      Given(:repo) { double(find_wiki: wiki, update_wiki: save_result) }
      Given(:attrs) { Attrs.wiki }
      Given(:save_result) { true }

      When { runner.run(wiki.id, attrs) }

      Then { callback.invoked == [:success, wiki] }
      Invariant { repo.should have_received(:find_wiki).with(wiki.id) }
      Invariant { repo.should have_received(:update_wiki).with(wiki, attrs) }

      context "with invalid attributes" do
        Given(:save_result) { false }
        Then { callback.invoked == [:failure, wiki] }
      end
    end

    describe Destroy do
      Given(:runner_under_test) { Destroy }
      Given(:repo) { double(find_wiki: wiki, destroy_wiki: true) }
      Given!(:wiki_name) { wiki.name }

      When(:result) { runner.run(wiki.id) }

      Then { result == [wiki_name] }
      Then { repo.should have_received(:find_wiki).with(wiki.id) }
      Then { repo.should have_received(:destroy_wiki).with(wiki.id) }
      Then { callback.invoked == [:success, wiki_name] }
    end
  end
end
