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

  def sync
    payload = ActiveSupport::JSON.decode(params[:payload])
    repository = Repository.where(html_url: payload["repository"]["url"]).first
    render text: "not authenticate" and return unless repository

    repository.generate_build(payload["ref"].split("/").last, payload["commits"].last)
    render text: "success"
  end
end
