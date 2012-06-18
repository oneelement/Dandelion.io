class AddressesController < ApplicationController
  
  def index
    @addresses = Address.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @addresses }
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
