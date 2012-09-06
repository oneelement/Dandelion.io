class UrlsController < ApplicationController
  def index
    @urls = Url.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @urls }
    end
  end
  
  def create
    @url = Url.new(params[:url])
    respond_to do |format|
      if @url.save
        format.json { render json: @url, status: :created, location: @url }
      else
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  # PUT /urls/1
  # PUT /urls/1.json
  def update
    @url = Url.find(params[:id])

    respond_to do |format|
      if @url.update_attributes(params[:url])
        format.html { redirect_to @url, notice: 'Contact was successfully updated.' }
        format.json { render json: @url }
      else
        format.html { render action: "edit" }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
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
