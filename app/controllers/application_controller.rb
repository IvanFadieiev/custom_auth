class ApplicationController < ActionController::Base
  include SessionAuth

  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find_by(token: session[:token]) if session[:token]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end
end
