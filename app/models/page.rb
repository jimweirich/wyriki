class Page < ActiveRecord::Base
  belongs_to :wiki

  validates :name,
    presence: true,
    format: { with: /\A([A-Z][a-z0-9]+){2,}\Z/, message: "is not a wiki name" }

end
