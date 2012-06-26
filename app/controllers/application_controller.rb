class ApplicationController < ActionController::Base
  before_filter :set_current_user
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  rescue_from UserNoEmailException do |exception|
    redirect_to edit_user_registration_path, alert: "Your must input your email before creating a repository! It is only used to receive notification."
  end

  def set_current_user
    User.current = current_user
  end
end
