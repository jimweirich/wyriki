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
end
