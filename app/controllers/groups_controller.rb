class GroupsController < ApplicationController
  
  load_and_authorize_resource
  
   def index
    @groups = Group.where(:user_id => current_user.id)

    if @groups.nil?
      @groups = []
    end

    respond_to do |format|
      format.json { render_for_api :group, :json => @groups }
    end
  end
  
  
  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
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
        format.json { render json: @group, status: :created, location: @group }
      else
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
        format.json { render_for_api :group, :json => @group }
      else
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
  
  def multiplemerge
    master_id = params[:master]
    ids = params[:sent]
    #array = ids.split(",")
    #@output = []
    master_index = ids.index(master_id)
    ids.delete_at(master_index)
    #use array.index then delete or get at index
    #array.delete_at(0)
    @do_group_save = false
    @master_group = Group.find(master_id)
    ids.each do |id|
      @group = Group.find(id) 
      @phones = @group.phones
      @phones.each do |model|
        text = model.number
	type = model._type
	parent_id = model.parent_id
	@master_group.phones.create!(
	  :_type => type,
	  :number => text,
	  :parent_id => parent_id
	)
      end
      @emails = @group.emails
      @emails.each do |model|
        text = model.text
	type = model._type
	parent_id = model.parent_id
	@master_group.emails.create!(
	  :_type => type,
	  :text => text,
	  :parent_id => parent_id
	)
      end
      @addresses = @group.addresses
      @addresses.each do |model|
        text = model.full_address
	type = model._type
	parent_id = model.parent_id
	@master_group.addresses.create!(
	  :_type => type,
	  :full_address => text,
	  :parent_id => parent_id
	)
      end
      @urls = @group.urls
      @urls.each do |model|
        text = model.text
	type = model._type
	parent_id = model.parent_id
	@master_group.urls.create!(
	  :_type => type,
	  :text => text,
	  :parent_id => parent_id
	)
      end
      @notes = @group.notes
      @notes.each do |model|
        text = model.text
	type = model._type
	@master_group.notes.create!(
	  :_type => type,
	  :text => text
	)
      end
      if @group.avatar
        if @master_group.avatar
	else
	  @master_group.avatar = @group.avatar
	  @do_group_save = true
	end
      end
      if @group.facebook_id
        if @master_group.facebook_id
	else
	  @master_group.facebook_id = @group.facebook_id
	  @master_group.facebook_handle = @group.facebook_handle
	  @master_group.facebook_picture = @group.facebook_picture
	  @do_group_save = true
	end
      end
      if @group.twitter_id
        if @master_group.twitter_id
	else
	  @master_group.twitter_id = @group.twitter_id
	  @master_group.twitter_handle = @group.twitter_handle
	  @master_group.twitter_picture = @group.twitter_picture
	  @do_group_save = true
	end
      end
      if @group.linkedin_id
        if @master_group.linkedin_id
	else
	  @master_group.linkedin_id = @group.linkedin_id
	  @master_group.linkedin_handle = @group.linkedin_handle
	  @master_group.linkedin_picture = @group.linkedin_picture
	  @do_group_save = true
	end
      end
      if @group
        @group.destroy
      end
    end
    if @do_group_save == true
      @master_group.save
    end
    
    respond_to do |format|
      format.json { render json: ids, status: :created, location: @group }
    end
  end
  
end
