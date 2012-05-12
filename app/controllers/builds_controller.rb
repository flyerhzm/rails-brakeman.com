class BuildsController < ApplicationController
  before_filter :load_repository

  def show
    @build = @repository.builds.find(params[:id])
    @active_class_name = "build"
  end

  def index
    @builds = @repository.builds
    @active_class_name = "history"
  end

  protected
    def load_repository
      @repository = Repository.find(params[:repository_id])
    end
end
