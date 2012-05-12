class ApplicationController < ActionController::Base
  before_filter :set_current_user
  protect_from_forgery

  def set_current_user
    User.current = current_user
  end
end
