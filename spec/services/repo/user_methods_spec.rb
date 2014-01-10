require 'spec_helper'

module Repo

  class UserRepo
    include UserMethods
  end

  describe UserMethods do
    Given(:repo) { UserRepo.new }

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

      Then { saved }
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

      Then { saved }
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
  end
end
