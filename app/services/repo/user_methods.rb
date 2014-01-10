module Repo
  module UserMethods
    def all_users
      Biz::User.wraps(User.all_users)
    end

    def new_user(attrs={})
      Biz::User.wrap(User.new(attrs))
    end

    def find_user(user_id)
      Biz::User.wrap(User.find(user_id))
    end

    def save_user(user)
      user.data.save
    end

    def update_user(user, attrs)
      user.data.update_attributes(attrs)
    end

    def destroy_user(user_id)
      User.destroy(user_id)
    end
  end
end
