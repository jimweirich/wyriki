require 'spec_helper'

describe User do
  Given(:valid_attrs) { { name: "Adam", email: "adam@adam" } }
  Given(:password_attrs) { valid_attrs.merge(password: "secret", password_confirmation: "secret") }
  Given(:attrs) { valid_attrs }
  Given(:user) { User.new(attrs) }

  describe "validations" do
    context "with valid attributes" do
      Given(:attrs) { password_attrs }
      Then { must_be_valid(user) }
    end

    context "with missing name" do
      Given(:attrs) { password_attrs.merge(name: nil) }
      Then { must_be_invalid(user, :name, /blank/) }
    end

    context "with missing email" do
      Given(:attrs) { password_attrs.merge(email: nil) }
      Then { must_be_invalid(user, :email, /blank/) }
    end

    context "with ill-formatted email" do
      Given(:attrs) { password_attrs.merge(email: "X") }
      Then { must_be_invalid(user, :email, /not.*valid/) }
    end

    context "with missing password" do
      Given(:attrs) { password_attrs.merge(password: nil) }
      Then { must_be_invalid(user, :password, /blank/) }
    end

    context "with missing password confirmation" do
      Given(:attrs) { password_attrs.merge(password_confirmation: nil) }
      Then { must_be_invalid(user, :password_confirmation, /blank/) }
    end
  end

  describe "finding roles" do
    Given!(:user) { User.create!(Attrs.user) }
    Given!(:wiki1) { Wiki.create!(Attrs.wiki(name: "Wiki1")) }
    Given!(:wiki2) { Wiki.create!(Attrs.wiki(name: "Wiki2")) }
    Given!(:perm) { user.permissions.create(wiki: wiki1, role: "writer") }
    context "with a existing writer role" do
      Then { user.permission_for(wiki1).role == "writer" }
      Then { user.permission_for(wiki1) == perm }
      Then { user.can_read?(wiki1) }
      Then { user.can_write?(wiki1) }
      Then { ! user.can_administrate?(wiki1) }
    end
    context "with an implicit reader role" do
      Then { user.permission_for(wiki2).role == "reader" }
      Then { user.can_read?(wiki2) }
      Then { ! user.can_write?(wiki2) }
      Then { ! user.can_administrate?(wiki1) }
    end
  end

  describe "roles and permissions" do
    Given(:wiki) { :wiki }
    Given(:perm) { Permission.new(role: role) }
    Given { user.stub(permission_for: perm) }

    context "with a reader role" do
      Given(:role) { "reader" }
      Then { user.can_read?(wiki) }
      Then { ! user.can_write?(wiki) }
      Then { ! user.can_administrate?(wiki) }
    end

    context "with a writer role" do
      Given(:role) { "writer" }
      Then { user.can_read?(wiki) }
      Then { user.can_write?(wiki) }
      Then { ! user.can_administrate?(wiki) }
    end

    context "with a admin role" do
      Given(:role) { "admin" }
      Then { user.can_read?(wiki) }
      Then { user.can_write?(wiki) }
      Then { user.can_administrate?(wiki) }
    end
  end
end
