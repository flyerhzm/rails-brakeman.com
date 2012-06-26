require "spec_helper"

describe "GET to :owner_name/:repository_name" do
  it "should route to RepositoriesController#show" do
    {get: 'flyerhzm/rails-brakeman.com'}.should route_to(
      controller: "repositories",
      action: "show",
      owner_name: "flyerhzm",
      repository_name: "rails-brakeman.com"
    )
  end
end
