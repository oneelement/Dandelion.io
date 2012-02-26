class QuestionsController < ApplicationController
  def index
    if params[:suggestions]
      if params[:section_id]
        @current_section = Section.find(params[:section_id])
        @questions = @current_section.suggested_questions
      end
    else
      @questions = Question.all
    end

    respond_to do |format|
      format.json { render json: @questions }
    end
  end

  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.json { render json: @question }
    end
  end
end
