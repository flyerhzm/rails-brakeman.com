class ApplicationController < ActionController::Base
  before_filter :set_current_user, :load_latest_repositories
  protect_from_forgery

  def set_current_user
    User.current = current_user
  end

  def load_latest_repositories
    @latest_repositories = Repository.where("builds_count > 0").order("last_build_at desc").limit(10)
  end
end
