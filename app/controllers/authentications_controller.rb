class AuthenticationsController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @authentications = Authentication.where(:user_id => current_user.id)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authentications }
    end
  end
  
  def create
    omniauth = request.env["omniauth.auth"]
    #current_user.authentications.where(:provider => omniauth['provider']).delete_all
    authentication = Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
    #current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
    if authentication
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user     
      current_user.authentications.where(:provider => omniauth['provider']).delete_all
      current_user.authentications.create(
	:provider => omniauth['provider'], 
	:uid => omniauth['uid'],
	:token => omniauth['credentials']['token'],
	:secret => omniauth['credentials']['secret']
      )
      flash[:notice] = "Authentication successful"
      if omniauth['provider'] == 'facebook'
	contact = Contact.find(current_user.contact_id)
	contact.facebook_handle = omniauth['extra']['raw_info']['link']
	contact.facebook_picture = omniauth['info']['image']
	contact.facebook_id = omniauth['uid']
	contact.save      
      end
      if omniauth['provider'] == 'twitter'
	contact = Contact.find(current_user.contact_id)
	contact.twitter_handle = omniauth['info']['urls']['Twitter']
	contact.twitter_picture = omniauth['info']['image']
	contact.twitter_id = omniauth['info']['nickname']
	contact.save      
      end
      if omniauth['provider'] == 'linkedin'
	contact = Contact.find(current_user.contact_id)
        @user = User.find(current_user.id)
	person = @user.linkedin.profile(:id => omniauth['uid'], :fields => [:picture_url])
	contact.linkedin_handle = omniauth['info']['urls']['public_profile']
	contact.linkedin_picture = person.picture_url
	contact.linkedin_id = omniauth['uid']
	contact.save      
      end
      redirect_to '/#auth/accept'
    elsif user = create_new_omniauth_user(omniauth)
      user.authentications.create!(
	:provider => omniauth['provider'], 
	:uid => omniauth['uid'],
	:token => omniauth['credentials']['token'],
	:secret => omniauth['credentials']['secret']
      )
      sign_in_and_redirect(:user, user)
    else
      flash[:notice] = "Please sign up manually."
      session[:omniauth] = omniauth.except('extra')
      redirect_to new_user_registration_url
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to current_user
  end
  
  def create_new_omniauth_user(omniauth)
    user = User.new
    user.apply_omniauth(omniauth)
    if user.save
      user.contact_create(omniauth)
      return user
    else
      nil
    end
  end
  
  #protected

  # This is necessary since Rails 3.0.4
  # See https://github.com/intridea/omniauth/issues/185
  # and http://www.arailsdemo.com/posts/44
  #def handle_unverified_request
    #true
  #end

end
