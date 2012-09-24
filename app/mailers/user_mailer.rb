class UserMailer < ActionMailer::Base
  #default :from => "register@dandelion.io"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  #
  def signup_confirmation(user)
    @greeting = "Hi"
    @user = user
    email_with_name = "Dandelion Team <register@dandelion.io>"

    mail :from => email_with_name, :to => user.email, :subject => "Welcome to Dandelion!", :bcc => "oliver@bespokd.com, ben@bespokd.com"
  end
end
