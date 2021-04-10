class BuildsController < ApplicationController
  before_action :load_repository
  before_action :load_build, only: [:show, :analyze_file]
  before_action :load_builds, only: :index
  authorize_resource except: :analyze_file

  def show
    if params[:repository_id]
      redirect_to user_repo_build_path(
                    owner_name: @repository.user.nickname,
                    repository_name: @repository.name,
                    id: @build.id
                  ),
                  status: 301 and return
    end

    @active_class_name = 'build'
  end

  def index
    if params[:repository_id]
      redirect_to user_repo_builds_path(owner_name: @repository.user.nickname, repository_name: @repository.name),
                  status: 301 and return
    end

    @active_class_name = 'history'
  end

  def analyze_file
    render inline: File.read(@build.analyze_file)
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
