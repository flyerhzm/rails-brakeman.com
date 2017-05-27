class RepositoriesController < ApplicationController
  before_action :load_resource, only: [:show, :badge]
  load_and_authorize_resource except: [:show, :badge, :sync]
  skip_before_action :set_current_user, only: :sync
  before_action :authenticate_user!, except: [:show, :badge, :sync]
  before_action :force_input_email, only: [:new, :create]
  before_action :check_github_authenticate, only: [:sync]

  def new
    @repository = current_user.repositories.new
  end

  def create
    github_name = repository_params[:github_name]
    if own_repository?(github_name) || org_repository?(github_name)
      @repository = current_user.repositories.build(repository_params)
      if @repository.save
        redirect_to [:edit, @repository]
      else
        render :new
      end
    else
      flash[:error] = "Only the repository owner can create a repository."
      redirect_to action: :new
    end
  rescue URI::InvalidURIError, Octokit::NotFound
    flash[:error] = "There is no such repository or you don't have access to such repository on github"
    redirect_to action: :new
  end

  def edit
  end

  def update
    if @repository.update_attributes(repository_params)
      redirect_to [:edit, @repository], notice: "Repository updated successfully"
    else
      render :edit
    end
  end

  def show
    redirect_to user_repo_path(owner_name: @repository.owner_name, repository_name: @repository.name), status: 301 and return if params[:id]
    @build = @repository.builds.completed.last

    authorize! :read, @repository
    if @build
      @active_class_name = "current"
      render 'builds/show' and return
    end
  end

  def badge
    redirect_to user_repo_path(owner_name: @repository.owner_name, repository_name: @repository.name), status: 301 and return if params[:id]
    @build = @repository.builds.completed.last

    if @build
      send_file Rails.root.join("public/images/#{@build.badge_state}.png"), type: 'image/png', disposition: 'inline'
    else
      send_file Rails.root.join("public/images/unknown.png"), type: 'image/png', disposition: 'inline'
    end
  end

  def sync
    render text: "no private repository" and return if @repository.private?
    render text: "not rails repository" and return unless @repository.rails?

    @repository.generate_build(@payload["ref"].split("/").last, @payload["commits"].last)
    render text: "success"
  end

  protected
    def load_resource
      if params[:owner_name] && params[:repository_name]
        @repository = Repository.where(github_name: "#{params[:owner_name]}/#{params[:repository_name]}").first
      elsif params[:id]
        @repository = Repository.find(params[:id])
      end
      render_404 if @repository.nil?
    end

    def check_github_authenticate
      @payload = ActiveSupport::JSON.decode(params[:payload])
      @repository = Repository.where(html_url: @payload["repository"]["url"]).first
      render text: "not authenticate" and return unless @repository
      render text: "not authenticate" and return unless @repository.authentication_token == params["token"]
    end

    def own_repository?(github_name)
      github_name.include?("/") && github_name.split("/").first == current_user.nickname
    end

    def org_repository?(github_name)
      client = Octokit::Client.new(oauth_token: current_user.github_token)
      collaborators = client.collaborators(github_name)
      collaborators && collaborators.any? { |collaborator| collaborator.id == current_user.github_uid }
    end

    def force_input_email
      raise UserNoEmailException if current_user.fakemail?
    end

  def repository_params
    params.require(:repository).permit(:description, :fork, :github_id, :github_name, :git_url, :html_url, :ssh_url, :name, :private, :visible, :rails, :pushed_at)
  end
end
