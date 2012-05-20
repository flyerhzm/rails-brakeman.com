class ApplicationController < ActionController::Base
  before_filter :set_current_user, :load_latest_repositories
  protect_from_forgery

  rescue_from UserNoEmailException do |exception|
    redirect_to edit_user_registration_path, alert: "Your must input your email before creating a repository! It is only used to receive notification."
  end

  def set_current_user
    User.current = current_user
  end

  def load_latest_repositories
    @latest_repositories = Repository.latest.limit(10)
  end
end
