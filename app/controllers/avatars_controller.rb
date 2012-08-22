class AvatarsController < ApplicationController
  def create
    @avatar = Avatar.new(params[:avatar])
    @avatar.update_attributes(user_id: current_user.id)
    respond_to do |format|
      if @avatar.save
        format.json { render json: @avatar, status: :created, location: @avatar }
      else
        format.json { render json: @avatar.errors, status: :unprocessable_entity }
      end
    end
  end
end
