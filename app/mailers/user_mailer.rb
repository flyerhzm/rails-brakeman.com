class UserMailer < ActionMailer::Base
  mailer_account "notification"

  default from: "notification@rails-brakeman.com"

  def notify_build_success(build)
    @build = build
    @repository = @build.repository

    mail(to: @repository.user.email,
         subject: "[rails-brakeman] #{@repository.github_name} build ##{@build.position}")
  end
end
