class UserController < ApplicationController
  
  layout "home"
  load_and_authorize_resource
  
  def currentuser
    @user ||= User.find(current_user.id) #find(:_id => current_user.id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  
  def current
    @user ||= User.find(current_user.id) #find(:_id => current_user.id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render_for_api :user, :json => @user }
    end
  end
  
  # GET /user
  # GET /user.json
  def index
    if params[:current]
      current
    else
      @users = User.all #excludes(:id => current_user.id)
      if current_user.user_type.name == "Organisation"
        @users = @users.where(:organisation_id => current_user.organisation_id)
      elsif current_user.user_type.name == "Entity"
        @users = @users.where(:entity_id => current_user.entity_id)
      elsif current_user.user_type.name == "Consumer"
        @users = @users.where(:_id => current_user.id)
        #redirect_to root_path
      end
      
      @organisations = Organisation.all
      
      if current_user.user_type.name == "Consumer"
        respond_to do |format|
          format.html { redirect_to root_path } # index.html.erb
          format.json { render_for_api :user, :json => @users }
        end
      else
        respond_to do |format|
          format.html # index.html.erb
          format.json { render_for_api :user, :json => @users }
        end
      end
    end
  end

  # GET /user/1
  # GET /user/1.json
  def show
    @user = User.find(params[:id])
    if @user.facebook
      @friends = @user.facebook.get_connections("me", "friends")
      @friends.each do |face|        
        id = face["id"]
        if FacebookFriend.where(:facebook_id => id, :user_id => current_user.id).exists?
        else
          name = face["name"]
          friend = FacebookFriend.new(:name => name, :facebook_id => id, :user_id => current_user.id)
          friend.save
        end
      end
      @facefriends = FacebookFriend.where(:user_id => current_user.id).asc(:name)
      #would be nice if this was kept to just the exists clause, OC, check contact.rb clear_delete method
      @facefriends = @facefriends.any_of({ :contact_id.exists => false }, { :contact_id => "" })      
    end
    #@friends.sort_by{|e| e["name"]}
    
    if @user.linkedin
      @connections = @user.linkedin.connections
      @connections = @connections.all
      @connections.each do |connection|
	id = connection.id
        if LinkedinConnection.where(:linkedin_id => id, :user_id => current_user.id).exists?
        else
          name = connection.first_name + " " + connection.last_name
          if connection.id != "private"
            connection = LinkedinConnection.new(:name => name, :linkedin_id => id, :user_id => current_user.id)
            connection.save
          end
        end
      end
      @linkedin = LinkedinConnection.where(:user_id => current_user.id).asc(:name)
      @linkedin = @linkedin.any_of({ :contact_id.exists => false }, { :contact_id => "" })    
    end
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render_for_api :user, :json => @user }
    end
  end

  # GET /user/new
  # GET /user/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /user/newent
  # GET /user/newent.json
  def newent
    @user = User.new
    respond_to do |format|
      format.html # newent.html.erb
      format.json { render json: @user }
    end
  end

  # GET /user/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /user
  # POST /user.json
  def create
    @user = User.new(params[:user])
    if current_user 
      @user.update_attributes(organisation_id: current_user.organisation_id)
    end
    #if @user.save
      #if session[:omniauth]
	#@user.authentications.create!(:provider => session[:omniauth]['provider'], :uid => session[:omniauth]['uid'])
      #end
    #end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user/1
  # PUT /user/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes_from_api(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render_for_api :user, :json => @user }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user/1
  # DELETE /user/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to user_index_url }
      format.json { head :ok }
    end
  end
end
