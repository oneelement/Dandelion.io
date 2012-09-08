class PositionsController < ApplicationController
  
  def index
    @positions = Position.all

    respond_to do |format|
      format.json { render json: @positions }
    end
  end
  
  def create
    @position = Position.new(params[:position])
    respond_to do |format|
      if @position.save
        format.json { render json: @position, status: :created, location: @position }
      else
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @position = Position.find(params[:id])

    respond_to do |format|
      if @position.update_attributes(params[:position])
        format.json { render json: @position }
      else
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @position = Position.find(params[:id])
    @position.destroy

    respond_to do |format|
      format.json { head :ok }
    end
  end

end
