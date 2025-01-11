class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("noreply@best-condition-note.com", "Best Condition Note")
  layout "mailer"
end
