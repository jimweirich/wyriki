class Wiki < ActiveRecord::Base
  include Biz::Mimic

  has_many :pages, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :home_page,
    presence: true,
    format: { with: /\A([A-Z][a-z0-9]+){2,}\Z/, message: "is not a wiki name" }

  def self.active_wikis
    all.order("name")
  end

  def page?(page_name)
    page = pages.where("name = ?", page_name).first
    ! page.nil?
  end
end
