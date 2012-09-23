class PhonesController < ApplicationController
  
  def index
    @phones = Phone.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @phones }
    end
  end
  
  def create
    @phone = Phone.new(params[:phone])
    respond_to do |format|
      if @phone.save
        format.json { render :json => @phone, :status => :created, :location => @phone }
      else
        format.json { render :json => @phone.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /phones/1
  # PUT /phones/1.json
  def update
    @phone = Phone.find(params[:id])

    respond_to do |format|
      if @phone.update_attributes(params[:phone])
        format.html { redirect_to @phone, :notice => 'Contact was successfully updated.' }
        format.json { render :json => @phone }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @phone.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @phone = Phone.find(params[:id])
    @phone.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :ok }
    end
  end
  
  def ripple
    @phones = Phone.where(:contact_id => params[:id])
    
    respond_to do |format|
      format.json { render :json => @phones }
    end
  end
end
