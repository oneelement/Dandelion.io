class PublicController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :about, :terms, :privacy, :contact, :contact_create]
  
  def index
    if current_user
      redirect_to '/app/'
    end
  end
  
  def about
     if current_user
      redirect_to '/app/'
    end
  end
  
  def terms
    if current_user
      redirect_to '/app/'
    end
  end
  
  def privacy
    if current_user
      redirect_to '/app/'
    end
  end
  
  def contact
    if current_user
      redirect_to '/app/'
    else
      @message = Message.new
    end
  end
  
  def contact_create
    if current_user
      redirect_to '/app/'
    else
      @message = Message.new(params[:message])
      if @message.valid?
	# end message here
	WebsiteMailer.delay.contact_form(@message)
	redirect_to "/contact", :notice => "Message sent! Thank you for contacting us."
      else
	render :contact
      end
    end
  end
  
end
