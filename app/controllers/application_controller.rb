require 'backbone_helpers'

class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :authenticate_user!
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url
  end
  
  include BackboneHelpers::Controller
end
