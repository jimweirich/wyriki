require 'fast_helper'
require 'app/runners/permission_runners'

module PermissionRunners
  describe PermissionRunners do
    Given(:context) { double(repo: repo) }
    Given(:callback) { FauxCallback.new }
    Given(:cb_config) { callback.configure(:page_not_found) }

    Given(:wiki) { double(id: 432, name: "Wik") }
    Given(:user) { double(id: 433, name: "bob") }
    Given(:perm) { double(id: 434, role: "writer") }

    Given(:saved) { true }
    Given(:role) { "writer" }

    Given(:repo) {
      double(
        find_wiki: wiki,
        find_user: user,
        new_permission: perm,
        save_permission: saved,
        find_permission_for: perm,
        update_permission: saved)
    }

    Given(:runner) {
      runner_under_test.new(context, &cb_config)
    }

    describe Create do
      Given(:runner_under_test) { Create }

      When { runner.run(wiki.id, user.id, role) }

      Then { callback.invoked == [:success, user, "bob is now a writer on Wik"] }

      Invariant { repo.should have_received(:find_wiki).with(wiki.id) }
      Invariant { repo.should have_received(:find_user).with(user.id) }
      Invariant {
        repo.should have_received(:new_permission).
        with(user: user, wiki: wiki, role: role)
      }
      Invariant { repo.should have_received(:save_permission).with(perm) }

      describe "with a bad role" do
        Given(:saved) { false }
        Then { callback.invoked == [:failure, user] }
      end
    end

    describe Update do
      Given(:runner_under_test) { Update }

      When { runner.run(wiki.id, user.id, role) }

      Then { callback.invoked == [:success, user, "bob is now a writer on Wik"] }

      Invariant { repo.should have_received(:find_wiki).with(wiki.id) }
      Invariant { repo.should have_received(:find_user).with(user.id) }
      Invariant { repo.should have_received(:find_permission_for). with(wiki, user) }
      Invariant { repo.should have_received(:update_permission).with(perm, role: role) }

      describe "with a bad role" do
        Given(:saved) { false }
        Then { callback.invoked == [:failure, user] }
      end
    end

  end
end
