class AddressesController < ApplicationController
  
  def index
    @addresses = Address.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @addresses }
    end
  end
  
  def create
    @address = Address.new(params[:address])
    respond_to do |format|
      if @address.save
        format.json { render json: @address, status: :created, location: @address }
      else
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /addresses/1
  # PUT /addresses/1.json
  def update
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render json: @address }
      else
        format.html { render action: "edit" }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :ok }
    end
  end

end
