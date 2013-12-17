class Wiki < ActiveRecord::Base
  validates :name, presence: true
  validates :home_page,
    presence: true,
    format: { with: /\A([A-Z][a-z0-9]+){2,}\Z/, message: "is not a wiki name" }
end
