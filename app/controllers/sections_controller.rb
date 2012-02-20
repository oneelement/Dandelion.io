class SectionsController < ApplicationController
  def index
    if params[:topLevel]
      @sections = Section.top_level
    else
      @sections = Section.all
    end

    respond_to do |format|
      format.json { render json: @sections }
    end
  end

  def show
    @section = Section.find(params[:id])

    respond_to do |format|
      format.json { render json: @section }
    end
  end
end
