require 'fast_helper'
require 'app/runners/user_runners'

module UserRunners
  describe UserRunners do
    Given(:context) { double(repo: repo) }
    Given(:callback) { FauxCallback.new }
    Given(:cb_config) { callback.configure(:page_not_found) }

    Given(:user) { double(id: 1234) }

    Given(:runner) {
      runner_under_test.new(context, &cb_config)
    }

    describe Index do
      Given(:runner_under_test) { Index }
      Given(:repo) { double(all_users: [:u1, :u2]) }

      When(:result) { runner.run }

      Then { result == [[:u1, :u2]] }
      Then { callback.invoked(:success, [:u1, :u2]) }
      Then { repo.should have_received(:all_users).with() }
    end

    describe Show do
      Given(:runner_under_test) { Show }
      Given(:repo) { double(find_user: user, active_wikis: [:wiki]) }

      When(:result) { runner.run(user.id) }

      Then { result == [user, [:wiki]] }
      Then { repo.should have_received(:find_user).with(user.id) }
      Then { repo.should have_received(:active_wikis).with() }
      Then { callback.invoked(:success, [:u1, :u2]) }
    end

    describe New do
      Given(:runner_under_test) { New }
      Given(:repo) { double(new_user: user) }

      When(:result) { runner.run }

      Then { result == [user] }
      Then { repo.should have_received(:new_user).with() }
      Then { callback.invoked == [:success, user] }
    end

    describe Create do
      Given(:runner_under_test) { Create }
      Given(:repo) { double(new_user: user, save_user: saved) }
      Given(:saved) { true }
      Given(:attrs) { Attrs.user }

      When(:result) { runner.run(attrs) }

      Then { result == [user] }
      Then { callback.invoked == [:success, user] }

      Invariant { repo.should have_received(:new_user).with(attrs) }
      Invariant { repo.should have_received(:save_user).with(user) }

      context "with invalid user" do
        Given(:saved) { false }
        Then { result == [user] }
        Then { callback.invoked == [:failure, user] }
      end
    end

    describe Edit do
      Given(:runner_under_test) { Edit }
      Given(:repo) { double(find_user: user) }

      When(:result) { runner.run(user.id) }

      Then { result == [user] }
      Then { repo.should have_received(:find_user).with(user.id) }
      Then { callback.invoked == [:success, user] }
    end

    describe Update do
      Given(:runner_under_test) { Update }
      Given(:repo) { double(find_user: user, update_user: saved) }
      Given(:saved) { true }
      Given(:attrs) { Attrs.user }

      When(:result) { runner.run(user.id, attrs) }

      Then { result == [user] }
      Then { callback.invoked == [:success, user] }

      Invariant { repo.should have_received(:find_user).with(user.id) }
      Invariant { repo.should have_received(:update_user).with(user, attrs) }

      context "with invalid user" do
        Given(:saved) { false }
        Then { result == [user] }
        Then { callback.invoked == [:failure, user] }
      end
    end

    describe Destroy do
      Given(:runner_under_test) { Destroy }
      Given(:repo) { double(destroy_user: true) }

      When { runner.run(user.id) }

      Then { repo.should have_received(:destroy_user).with(user.id) }
      Then { callback.invoked == [:success] }
    end

  end
end
