module Biz

  # Include in ActiveRecord models to mimic Biz models.
  module Mimic
    def data
      self
    end

    def biz?
      false
    end
  end

end
