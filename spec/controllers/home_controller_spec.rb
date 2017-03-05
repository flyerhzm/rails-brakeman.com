require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before { stubs_current_user }

  context "GET :index" do
    it "should response ok" do
      get :index
      expect(response).to be_ok
    end
  end
end
