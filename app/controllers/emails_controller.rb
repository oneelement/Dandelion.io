class EmailsController < ApplicationController
  
  def index
    @emails = Email.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @emails }
    end
  end
  
  def create
    @email = Email.new(params[:email])
    respond_to do |format|
      if @email.save
        format.json { render json: @email, status: :created, location: @email }
      else
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /emails/1
  # PUT /emails/1.json
  def update
    @email = Email.find(params[:id])

    respond_to do |format|
      if @email.update_attributes(params[:email])
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render json: @email }
      else
        format.html { render action: "edit" }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @email = Email.find(params[:id])
    @email.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :ok }
    end
  end
end
