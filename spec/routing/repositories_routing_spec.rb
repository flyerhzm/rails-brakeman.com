# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET to :owner_name/:repository_name", type: :routing do
  it "should route to RepositoriesController#show" do
    expect(get: 'flyerhzm/rails-brakeman.com').to route_to(
      controller: "repositories",
      action: "show",
      owner_name: "flyerhzm",
      repository_name: "rails-brakeman.com"
    )
  end
end
