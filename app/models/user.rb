class User < ActiveRecord::Base

  has_secure_password

  validates :name, presence: true
  validates :email,
    presence: true,
    format: { with: /\S@\S/, message: "is not a valid EMail address" }

  def self.all_users
    all.order("name")
  end

end
