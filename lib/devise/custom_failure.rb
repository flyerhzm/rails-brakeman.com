# frozen_string_literal: true

class Devise::CustomFailure < Devise::FailureApp
  def redirect_url
    root_url
  end
end

