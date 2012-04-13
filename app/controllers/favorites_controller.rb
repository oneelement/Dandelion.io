class FavoritesController < ApplicationController
  def index
    #@tasks = Task.all
    @favorites = Favorite.where(:user_id => current_user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @favorites }
    end
  end
  def new
    @favorite = Favorite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @favorite }
    end
  end

  def create
    @favorite = Favorite.new(params[:favorite])
    @favorite.update_attributes(user_id: current_user.id)
    respond_to do |format|
      if @favorite.save
        format.html { redirect_to @favorite, notice: 'Home was successfully created.' }
        format.json { render json: @favorite, status: :created, location: @favorite }
      else
        format.html { render action: "new" }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end
end
