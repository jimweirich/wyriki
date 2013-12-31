require 'fast_helper'
require 'app/runners/named_callbacks'

describe NamedCallbacks do
  Given(:nc) { NamedCallbacks.new }

  describe "with a named callback" do
    Given(:args) { [ ] }
    Given { nc.ok { |*a| args.replace(a) } }
    When { nc.call(:ok, 1, 2, 3) }
    Then { args == [1, 2, 3] }
  end

  describe "with a named callback called by a string" do
    Given(:args) { [ ] }
    Given { nc.ok { |*a| args.replace(a) } }
    When { nc.call("ok", 1, 2, 3) }
    Then { args == [1, 2, 3] }
  end

  describe "with a undeclared callback" do
    Given(:args) { [ ] }
    When(:result) { nc.call(:ok, 1, 2, 3) }
    Then { result }
    Then { args == [] }
  end
end
