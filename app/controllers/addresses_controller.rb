class AddressesController < ApplicationController
  
  def index
    @addresses = Address.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @addresses }
    end
  end

end
