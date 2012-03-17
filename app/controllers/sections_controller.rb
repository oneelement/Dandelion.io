class SectionsController < ApplicationController
  def index
    if params[:suggestions]
      if params[:id]
        @current_section = Section.find(params[:id])
        @sections = @current_section.suggested_child_sections
      else
        @sections = Section.top_level_suggestions
      end
    else
      @sections = Section.all
    end

    if @sections.nil?
      @sections = []
    end

    respond_to do |format|
      format.json { render_for_api :section, :json => @sections }
    end
  end

  def show
    @section = Section.find(params[:id])

    respond_to do |format|
      format.json { render json: @section }
    end
  end
end
