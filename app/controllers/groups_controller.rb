class GroupsController < ApplicationController
  
  load_and_authorize_resource
  
   def index
    @groups = Group.where(:user_id => current_user.id)

    if @groups.nil?
      @groups = []
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render_for_api :group, :json => @groups }
    end
  end
  
  
  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html { redirect_to root_path }
      #format.json { render json: @group }
      format.json { render_for_api :group, :json => @group }
    end
  end
  
  
  
  # POST /groups	
  # POST /groups.json
  def create
    @group = Group.new(params[:group])
    @group.update_attributes(user_id: current_user.id)
    respond_to do |format|
      if @group.save
        format.html { redirect_to root_path, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { redirect_to root_path }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes_from_api(params[:group])
        format.html { redirect_to root_path, notice: 'Group was successfully updated.' }
        format.json { render_for_api :group, :json => @group }
      else
        format.html { redirect_to root_path }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :ok }
    end
  end
  
  def multipledelete
    ids = params[:sent]
    array = ids.split(",")
    @output = []
    array.each do |id|
      @group = Group.find(id)      
      @output << @group.name
      @group.destroy
    end
    
    respond_to do |format|
      format.json { render json: @output, status: :created, location: @group }
    end
  end
  
end
