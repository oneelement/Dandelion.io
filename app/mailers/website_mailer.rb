class WebsiteMailer < ActionMailer::Base
  #default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.website_mailer.contact_form.subject
  #
  def contact_form(message)
    @message = message
    email_with_name = "Dandelion Team <contact@dandelion.io>"

    mail :from => email_with_name, :to => "oliver@bespokd.com, ben@bespokd.com", :subject => "Dandelion Contact Form"
  end
end
