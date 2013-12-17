module Validity
  module MustBeMixin
    def inspect
      to_bool if @why.nil?
      @why
    end

    private

    def error_descriptions
      if @model.errors.empty?
        ""
      else
        "\n  Errors were:\n    * " +
          @model.errors.full_messages.map { |msg| msg }.join("\n    * ")
      end
    end
  end

  class MustBeValid
    include MustBeMixin

    def initialize(model)
      @model = model
      @why = nil
    end

    def to_bool
      if @model.invalid?
        @why = "model #{@model.class} was invalid (expected valid)" + error_descriptions
        false
      else
        @why = "OK (expected valid)"
        true
      end
    end
  end

  class MustBeInvalid
    include MustBeMixin

    def initialize(model, field, pattern)
      @model = model
      @field = field
      @pattern = pattern
      @why = nil
    end

    def to_bool
      if @model.valid?
        @why = "#{@model.class} was valid (expected invalid)"
        false
      elsif @model.errors[@field].empty?
        @why = "#{@model.class} had no errors on field #{@field}" + error_descriptions
        false
      elsif @model.errors[@field].none? { |msg| msg =~ @pattern }
        @why = "#{@model.class} had no errors matching #{@pattern} on field #{@field}" + error_descriptions
        false
      else
        @why = "OK (expected invalid)"
        true
      end
    end
  end

  def must_be_valid(model)
    MustBeValid.new(model)
  end

  def must_be_invalid(model, field, pattern=//)
    MustBeInvalid.new(model, field, pattern)
  end
end

RSpec.configure do |c|
  c.include(Validity)
end
