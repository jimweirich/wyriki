class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  ROLES = ['reader', 'writer', 'admin']

  validates :wiki,
    presence: true

  validates :role,
    presence: true,
    inclusion: { in: ROLES, message: "is not one of #{ROLES.join(', ')}" }

  def can_read?
    true
  end

  def can_write?
    role == "writer" || role == "admin"
  end

  def can_administrate?
    role == "admin"
  end
end
