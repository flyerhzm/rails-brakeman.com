class UserMailer < ActionMailer::Base
  mailer_account "notification"

  default from: "notification@rails-brakeman.com"

  def notify_build_success(build)
    @build = build
    @repository = @build.repository

    mail(to: @repository.user_email,
         subject: "[rails-brakeman] #{@repository.github_name} build ##{@build.position}")
  end

  def notify_repository_privacy(repository)
    @repository = repository

    mail(to: @repository.user_email,
         subject: "[rails-brakeman] private repository #{@repository.github_name} on rails-brakeman.com")
  end
end
