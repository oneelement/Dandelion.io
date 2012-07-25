class PublicContactsController < ApplicationController
  
  def index
    @contacts = Contact.where(:is_user => true)
     
    respond_to do |format|
      format.json { render_for_api :public_contact, :json => @contacts }
    end
  end
  
  def show
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.json { render_for_api :public_contact, :json => @contact }
    end
  end
  
end
