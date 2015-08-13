class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if current_user.admin?
      admin_events_path
    else
      root_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id] ) if session[:user_id]
  end

  helper_method :current_user
end
