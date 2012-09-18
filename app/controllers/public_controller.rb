class PublicController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :about, :terms, :privacy, :contact]
  
  def index
    if current_user
      redirect_to '/app/'
    end
  end
  
  def about
     if current_user
      redirect_to '/app/'
    end
  end
  
  def terms
    if current_user
      redirect_to '/app/'
    end
  end
  
  def privacy
    if current_user
      redirect_to '/app/'
    end
  end
  
  def contact
    if current_user
      redirect_to '/app/'
    end
  end
  
end
