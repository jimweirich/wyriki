module Biz

  # Include in ActiveRecord models to mimic Biz wrappers.
  module Mimic
    def data
      self
    end

    def biz?
      false
    end
  end

end
