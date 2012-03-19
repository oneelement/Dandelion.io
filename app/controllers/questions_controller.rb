class QuestionsController < ApplicationController
  def index
    if params[:suggestions]
      if params[:section_id]
        @current_section = Section.find(params[:section_id])
        @questions = Question.children_of(@current_section).suggestions
      end
    elsif params[:custom]
      if params[:section_id]
        @current_section = Section.find(params[:section_id])
        @questions = Question.children_of(@current_section).custom
      end
    else
      @questions = Question.all
    end

    if @questions.nil?
      @questions = []
    end

    respond_to do |format|
      format.json { render_for_api :question, :json => @questions }
    end
  end

  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.json { render json: @question }
    end
  end
end
