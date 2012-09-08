class EducationsController < ApplicationController
  
  def index
    @educations = Education.all

    respond_to do |format|
      format.json { render json: @educations }
    end
  end
  
  def create
    @education = Education.new(params[:education])
    respond_to do |format|
      if @education.save
        format.json { render json: @education, status: :created, location: @education }
      else
        format.json { render json: @education.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @education = Education.find(params[:id])

    respond_to do |format|
      if @education.update_attributes(params[:education])
        format.json { render json: @education }
      else
        format.json { render json: @education.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @education = Education.find(params[:id])
    @education.destroy

    respond_to do |format|
      format.json { head :ok }
    end
  end

end
