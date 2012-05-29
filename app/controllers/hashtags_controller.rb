class HashtagsController < ApplicationController
  def index
    @hashtags = Hashtag.where(:user_id => current_user.id)
    
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: @hashtags }
    end
  end
  
  def show
    @hashtag = Hashtag.find(params[:id])

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: @hashtag }
    end
  end
  
  def create
    @hashtag = Hashtag.new(params[:hashtag])
    @hashtag.update_attributes(user_id: current_user.id)
    respond_to do |format|
      if @hashtag.save
        format.html { redirect_to root_path, notice: 'Hashtag was successfully created.' }
        format.json { render json: @hashtag, status: :created, location: @hashtag }
      else
        format.html { redirect_to root_path }
        format.json { render json: @hashtag.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @hashtag = Hashtag.find(params[:id])

    respond_to do |format|
      if @hashtag.update_attributes(params[:hashtag])
        format.html { redirect_to root_path, notice: 'Hashtag was successfully updated.' }
        format.json { render json: @hashtag }
      else
        format.html { redirect_to root_path }
        format.json { render json: @hashtag.errors, status: :unprocessable_entity }
      end
    end
  end
end
