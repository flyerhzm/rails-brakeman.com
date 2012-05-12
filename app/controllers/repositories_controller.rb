class RepositoriesController < ApplicationController
  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(params[:repository])
    if @repository.save
      redirect_to [:edit, @repository]
    else
      render :new
    end
  end

  def edit
    @repository = Repository.find(params[:id])
  end

  def update
    @repository = Repository.find(params[:id])
    if @repository.update_attributes(params[:repository])
      redirect_to [:edit, @repository], :notice => "Repository updated successfully"
    else
      render :edit
    end
  end

  def show
    @repository = Repository.find(params[:id])
    @build = @repository.builds.last
    @active_class_name = "current"
    render 'builds/show'
  end

  def sync
    payload = ActiveSupport::JSON.decode(params[:payload])
    repository = Repository.where(html_url: payload["repository"]["url"]).first
    render text: "not authenticate" and return unless repository

    repository.generate_build(payload["ref"].split("/").last, payload["commits"].last)
    render text: "success"
  end
end
