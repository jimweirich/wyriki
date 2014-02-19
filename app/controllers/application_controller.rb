class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def run(klass, *args, &block)
    klass.new(self, &block).run(*args)
  end

  def repo
    @repo = WikiRepository.new
  end
  helper_method :repo

  def current_user
    @current_user ||= begin
                        if session[:user_id]
                          User.find(session[:user_id])
                        else
                          DefaultUser::INSTANCE
                        end
                      end
  end
  helper_method :current_user

end
