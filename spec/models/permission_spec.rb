require 'spec_helper'

describe Permission do
  Given(:wiki) { Wiki.new(name: "Wiki") }
  Given(:valid_attrs) { { wiki: wiki, role: "reader" } }
  Given(:attrs) { valid_attrs }
  Given(:permission) { Permission.new(attrs) }

  describe "validations" do
    context "with valid attributes" do
      Then { must_be_valid(permission) }
    end

    context "with missing wiki" do
      Given(:attrs) { valid_attrs.merge(wiki: nil) }
      Then { must_be_invalid(permission, :wiki, /blank/) }
    end

    context "with missing role" do
      Given(:attrs) { valid_attrs.merge(role: nil) }
      Then { must_be_invalid(permission, :role, /blank/) }
    end

    context "with invalid role" do
      Given(:attrs) { valid_attrs.merge(role: "xyzzy") }
      Then { must_be_invalid(permission, :role, /reader.*writer.*admin/i) }
    end
  end

  describe "roles" do
    context "with a reader role" do
      Given(:attrs) { valid_attrs.merge(role: "reader") }
      Then { permission.can_read? }
      Then { ! permission.can_write? }
      Then { ! permission.can_administrate? }
    end

    context "with a writer role" do
      Given(:attrs) { valid_attrs.merge(role: "writer") }
      Then { permission.can_read? }
      Then { permission.can_write? }
      Then { ! permission.can_administrate? }
    end

    context "with a admin role" do
      Given(:attrs) { valid_attrs.merge(role: "admin") }
      Then { permission.can_read? }
      Then { permission.can_write? }
      Then { permission.can_administrate? }
    end
  end
end
