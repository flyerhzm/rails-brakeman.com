class BuildsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_repository

  def show
    @active_class_name = "build"
  end

  def index
    @builds = @repository.builds.completed
    @active_class_name = "history"
  end

  protected
    def load_repository
      @repository = Repository.find(params[:repository_id])
    end
end
