class BuildsController < ApplicationController
  before_filter :load_repository
  before_filter :load_build, only: :show
  before_filter :load_builds, only: :index
  authorize_resource

  def show
    redirect_to user_repo_build_path(owner_name: @repository.user.nickname, repository_name: @repository.name, id: @build.id), status: 301 and return if params[:repository_id]

    @active_class_name = "build"
  end

  def index
    redirect_to user_repo_builds_path(owner_name: @repository.user.nickname, repository_name: @repository.name), status: 301 and return if params[:repository_id]

    @active_class_name = "history"
  end

  protected
    def load_repository
      if params[:owner_name] && params[:repository_name]
        @repository = Repository.where(github_name: "#{params[:owner_name]}/#{params[:repository_name]}").first
      elsif params[:repository_id]
        @repository = Repository.find(params[:repository_id])
      end
      render_404 if @repository.nil?
    end

    def load_build
      @build = @repository.builds.find(params[:id])
    end

    def load_builds
      @builds = @repository.builds.completed
    end
end
