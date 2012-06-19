class PhonesController < ApplicationController
  
  def index
    @phones = Phone.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @phones }
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
end
