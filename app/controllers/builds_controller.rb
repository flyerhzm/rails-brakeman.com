class BuildsController < ApplicationController
  before_filter :load_repository
  before_filter :load_build, only: :show
  before_filter :load_builds, only: :index
  authorize_resource

  def show
    redirect_to "/#{@repository.user.nickname}/#{@repository.name}/builds/#{params[:id]}", status: 301 and return if @redirect

    @active_class_name = "build"
  end

  def index
    redirect_to "/#{@repository.user.nickname}/#{@repository.name}/builds", status: 301 and return if @redirect

    @active_class_name = "history"
  end

  protected
    def load_repository
      if params[:user_name] && params[:repository_name]
        @user = User.where(nickname: params[:user_name]).first
        @repository = @user.repositories.where(name: params[:repository_name]).first
      elsif params[:repository_id]
        @repository = Repository.find(params[:repository_id])
        @redirect = true
      end
    end

    def load_build
      @build = @repository.builds.find(params[:id])
    end

    def load_builds
      @builds = @repository.builds.completed
    end
end
