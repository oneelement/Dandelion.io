class DashboardController < ApplicationController
  layout "home"
  # GET /dashboards
  # GET /dashboards.json
  def index
    @dashboard = Dashboard.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dashboard }
    end
  end

end
