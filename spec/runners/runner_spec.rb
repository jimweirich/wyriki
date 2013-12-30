require 'fast_helper'
require 'app/runners/runner'

describe Runner do
  Given(:context) { double(invoked: true) }
  Given(:runner) {
    Runner.new(context) do |on|
      on.success { |a, b| context.invoked("SUCCESS", a, b) }
      on.failure { |a, b| context.invoked("FAILURE", a, b) }
      on.other   { |a, b| context.invoked("OTHER", a, b) }
    end
  }

  Invariant { runner.context == context }

  describe "calling success" do
    When { runner.success(1, 2) }
    Then { context.should have_received(:invoked).with("SUCCESS", 1, 2) }
  end

  describe "calling failure" do
    When { runner.failure(1, 2) }
    Then { context.should have_received(:invoked).with("FAILURE", 1, 2) }
  end

  describe "calling other" do
    When { runner.callback(:other, 1, 2) }
    Then { context.should have_received(:invoked).with("OTHER", 1, 2) }
  end

  describe "calling unknown" do
    When { runner.callback(:unknown, 1, 2) }
    Then { context.should_not have_received(:invoked) }
  end
end
