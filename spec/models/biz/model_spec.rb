require 'fast_helper'
require 'app/models/biz/model'
require 'app/models/biz/mimic'

module Biz
  DataModel = Struct.new(:name, :age) do
    include Biz::Mimic
  end

  describe Biz::Model do
    Given(:data) { DataModel.new("NAME", 40) }
    Given(:model) { Model.wrap(data) }

    describe "self identifies as a business model" do
      Then { model.biz? }
    end

    describe "exposes underlying data object on request" do
      Then { ! model.data.biz? }
    end

    describe "mimics underlying data" do
      Then { model.name == "NAME" }
      Then { model.age == 40 }
    end

    describe "lies about its class" do
      Then { model.class == model.data.class }
    end

    describe "compares equal to other equivalent models" do
      Then { model == Model.wrap(data) }
      Then { model == data }
      Then { data == model }
    end

    describe "compares not-equal to other stuff" do
      Given(:other_data) { DataModel.new("OTHER", 1) }
      Given(:other_model) { Model.wrap(other_data) }

      Then { model != other_data }
      Then { other_data != model }

      Then { model != other_model }
      Then { other_model != model }

      Then { model != :other }
      Then { :other != model }
    end

    describe "prohibits ActiveRecord methods" do
      When(:saved) { model.save }
      Then { saved.should have_failed(Biz::ActiveRecordNotAvailableError) }
    end

    describe "returns nil when wrapping nil objects" do
      Given(:data) { nil }
      Then { model.nil? }
    end

    describe "can wrap collections" do
      Given(:items) { [ DataModel.new("A", 1), DataModel.new("B", 2) ] }
      When(:models) { Model.wraps(items) }
      Then { models.all? { |m| m.biz? } }
    end
  end
end
