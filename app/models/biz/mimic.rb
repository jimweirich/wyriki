module Biz

  # Include in ActiveRecord models to mimic Biz models.
  module Mimic
    def data
      self
    end

    def biz?
      false
    end

    def ==(other)
      if other.respond_to?(:biz?) && other.biz?
        self == other.data
      else
        super
      end
    end
  end

end
