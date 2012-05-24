class RepositoriesController < ApplicationController
  load_and_authorize_resource except: :sync
  skip_before_filter :set_current_user, :load_latest_repositories, only: :sync
  before_filter :authenticate_user!, except: [:show, :sync]
  before_filter :force_input_email, only: [:new, :create]

  def new
    @repository = current_user.repositories.new
  end

  def create
    github_name = params[:repository][:github_name]
    if own_repository?(github_name) || org_repository?(github_name)
      @repository = current_user.repositories.build(params[:repository])
      if @repository.save
        redirect_to [:edit, @repository]
      else
        render :new
      end
    else
      flash[:error] = "Only the repository owner can create a repository."
      redirect_to :action => :new
    end
  rescue Octokit::NotFound
    flash[:error] = "There is no such repository or you don't have access to such repository on githbub"
    redirect_to action: :new
  end

  def edit
  end

  def update
    if @repository.update_attributes(params[:repository])
      redirect_to [:edit, @repository], :notice => "Repository updated successfully"
    else
      render :edit
    end
  end

  def show
    @build = @repository.builds.last
    if @build
      @active_class_name = "current"
      render 'builds/show' and return
    end
  end

  def sync
    payload = ActiveSupport::JSON.decode(params[:payload])
    repository = Repository.where(html_url: payload["repository"]["url"]).first
    render text: "not authenticate" and return unless repository
    render text: "not authenticate" and return unless repository.authentication_token == params["token"]

    repository.generate_build(payload["ref"].split("/").last, payload["commits"].last)
    render text: "success"
  end

  protected
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
end
