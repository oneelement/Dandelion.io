class ContactsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /contacts
  # GET /contacts.json
  def index
    if params[:search]
      @contacts = Contact.where(:user_id => current_user.id)
      @contacts = @contacts.where(:name => /#{params[:search]}/i)
    else
      @contacts = Contact.where(:user_id => current_user.id)
    end

    if @contacts.nil?
      @contacts = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render_for_api :contact, :json => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])
    p @contact.phones

    if @contact.socials.length == 0
      test_linkedin = SocialLinkedin.new(social_id: 'Example Name')
      test_twitter = SocialTwitter.new(social_id: '@examplename')
      test_facebook = SocialFacebook.new(social_id: 'Example Name')
      @contact.socials << test_linkedin
      @contact.socials << test_twitter
      @contact.socials << test_facebook
      @contact.save
    end

    @products = Product.find(:all)
    
    #@contact.address.build

    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @contact }
      format.json { render_for_api :contact, :json => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    if params[:search]
      @contact = Contact.new(:name => params[:search])
    else
      @contact = Contact.new
    end
    phone = @contact.phones.build
    address = @contact.addresses.build


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(params[:contact])
    @contact.update_attributes(user_id: current_user.id)
    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes_from_api(params[:contact])
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render_for_api :contact, :json => @contact }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :ok }
    end
  end

  def autocomplete
    # the autocomplete library needs a result in the form of
    # [{"label":"foo","value":"foo"},{"label":"bar","value":"bar"}]
    # or
    # [{"value":"foo"},{"value":"bar"}] if label and value are the same
    #
    # in this case we grab all movies that begin with the typed term and
    # rename the name attribute to value for convenience
    tasks = Task.where(:user_id => current_user.id)
    tasks = tasks.where(:title => /#{params[:term]}/i)
    contacts = Contact.where(:user_id => current_user.id)
    contacts = contacts.where(:name => /#{params[:term]}/i)
    list = contacts.map {|u| Hash[ id: u.id, label: u.name, name: u.name, category: "Contact", icon: "icon-avatar"]} + tasks.map {|u| Hash[ id: u.id, label: u.title, name: u.title, category: "Task", icon: "icon-group"]}
    #render json: list
    render :json => list.to_json
  end
end
