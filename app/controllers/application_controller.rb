require 'backbone_helpers'

class ApplicationController < ActionController::Base
  
  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      "application"
    else
      "application"
    end
  end
  
  protect_from_forgery
  before_filter :authenticate_user!
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url
  end
  
  def after_sign_in_path_for(resource)
    if resource.is_mobile == true
      "/app/"    
    else
      "/app/"
    end
  end
  
  include BackboneHelpers::Controller
end
