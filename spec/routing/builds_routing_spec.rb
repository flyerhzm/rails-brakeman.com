require "spec_helper"

describe "GET to :user_name/:repository_name/builds" do
  it "should route to BuildsController#index" do
    {get: 'flyerhzm/rails-brakeman.com/builds'}.should route_to(
      controller: "builds",
      action: "index",
      user_name: "flyerhzm",
      repository_name: "rails-brakeman.com"
    )
  end
end

describe "GET to :user_name/:repository_name/builds/:id" do
  it "should route to BuildsController#show" do
    {get: 'flyerhzm/rails-brakeman.com/builds/1'}.should route_to(
      controller: "builds",
      action: "show",
      user_name: "flyerhzm",
      repository_name: "rails-brakeman.com",
      id: "1"
    )
  end
end
