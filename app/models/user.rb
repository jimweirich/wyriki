class User < ActiveRecord::Base
  include Biz::Mimic

  has_many :permissions, dependent: :destroy

  has_secure_password

  validates :name, presence: true
  validates :email,
    presence: true,
    format: { with: /\S@\S/, message: "is not a valid EMail address" }

  def self.all_users
    all.order("name")
  end

  def permission_for(wiki)
    find_permission(wiki) || Permission.new(user: self, wiki: wiki, role: "reader")
  end

  def find_permission(wiki)
    permissions.where("wiki_id = ?", wiki.id).first
  end

  def can_read?(wiki)
    permission_for(wiki).can_read?
  end

  def can_write?(wiki)
    permission_for(wiki).can_write?
  end

  def can_administrate?(wiki)
    permission_for(wiki).can_administrate?
  end

  def logged_in?
    true
  end

  def self.authenticate(email, submitted_password)
    user = User.find_by_email(email)
    user && user.authenticate(submitted_password)
  end
end
