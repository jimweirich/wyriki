class WikiRepository
  include Repo::UserMethods
  include Repo::WikiMethods
  include Repo::PageMethods
  include Repo::PermissionMethods
end
