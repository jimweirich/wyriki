require 'spec_helper'

module Repo
  describe PermissionMethods do

    Given(:bad_id) { 999999999999999 }
    Given(:repo) { WikiRepository.new }

    Given!(:wiki) { Wiki.create!(Attrs.wiki) }
    Given!(:user) { User.create!(Attrs.user) }
    Given!(:role) { "writer" }
    Given!(:perm) { Permission.create(Attrs.permission(user: user, wiki: wiki)) }

    describe "#new_permission" do
      When(:new_perm) { repo.new_permission(wiki, user, role)}

      Then { new_perm.new_record? }
      Then { new_perm.user == user }
      Then { new_perm.wiki == wiki }
      Then { new_perm.role == role }
    end

    describe "#save_permission" do
      Given(:new_perm) { Permission.new(user: user, wiki: wiki, role: role) }

      When(:saved) { repo.save_permission(new_perm) }

      Then { saved }

      context "with bad attributes" do
        Given(:role) { "xyzzy" }
        Then { ! saved }
      end
    end

    describe "#find_permission_for" do
      context "with existsing permission" do
        When(:result) { repo.find_permission_for(wiki, user) }
        Then { result.wiki == wiki }
        Then { result.user == user }
        Then { result.role == role }
        Then { ! result.new_record? }
      end

      context "with missing permission" do
        Given!(:wiki2) { Wiki.create!(Attrs.wiki(name: "Other")) }
        When(:result) { repo.find_permission_for(wiki2, user) }
        Then { result.wiki == wiki2 }
        Then { result.user == user }
        Then { result.role == "reader" }
        Then { result.new_record? }
      end
    end

    describe "#update_permission" do
      When(:saved) { repo.update_permission(perm, role: "admin") }
      Then { saved }
      Then { repo.find_permission_for(wiki, user).role == "admin" }
    end
  end
end
