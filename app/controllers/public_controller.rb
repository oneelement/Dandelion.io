class PublicController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  
  def index
    if current_user
      redirect_to '/app/'
    end
  end
end
