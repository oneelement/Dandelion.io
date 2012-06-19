class UrlsController < ApplicationController
  def index
    @urls = Url.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @urls }
    end
  end
  
  def destroy
    @url = Url.find(params[:id])
    @url.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :ok }
    end
  end
end
