# Use this hook to configure contact mailer.
ContactUs.setup do |config|

  # ==> Mailer Configuration

  # Configure the e-mail address which email notifications should be sent from.  If emails must be sent from a verified email address you may set it here.
  # Example:
  # config.mailer_from = "contact@please-change-me.com"
  config.mailer_from = nil

  # Configure the e-mail address which should receive the contact form email notifications.
  config.mailer_to = "contact-us@rails-brakeman.com"

  # ==> Form Configuration

  # Configure the form to ask for the users name.
  config.require_name = true

  # Configure the form to ask for a subject.
  config.require_subject = true

  # Configure the form gem to use.
  config.form_gem = "simple_form"

end
