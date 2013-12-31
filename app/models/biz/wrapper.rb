require 'delegate'
require_dependency './app/models/biz/block_active_record'

module Biz
  class Wrapper < SimpleDelegator
    include BlockActiveRecord

    def data
      datum = self
      while datum.biz?
        datum = datum.__getobj__
      end
      datum
    end

    def ==(other)
      data == other.data
    end

    def biz?
      true
    end

    def class
      data.class
    end

    def self.wrap(model)
      model ? new(model) : nil
    end

    def self.wraps(models)
      models.map { |model| wrap(model) }
    end

  end
end
