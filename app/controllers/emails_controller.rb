class EmailsController < ApplicationController
  
  def index
    @emails = Email.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @emails }
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
