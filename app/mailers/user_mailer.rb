# frozen_string_literal: true

class UserMailer < ActionMailer::Base
  default from: "notification@rails-brakeman.com"

  def notify_build_success(build)
    @build = build
    @repository = @build.repository

    mail(to: @repository.user_email,
         subject: "[rails-brakeman] #{@repository.github_name} build ##{@build.position} warnings count #{@build.warnings_count}")
  end
end
