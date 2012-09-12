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
      format.html { redirect_to root_path }
      format.json { render_for_api :contact, :json => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])
    #@contact.phones

    #if @contact.socials.length == 0
      #test_linkedin = SocialLinkedin.new(social_id: 'Example Name')
      #test_twitter = SocialTwitter.new(social_id: 'chestermano')
      #test_facebook = SocialFacebook.new(social_id: 'Example Name')
      #@contact.socials << test_linkedin
      #@contact.socials << test_twitter
      #@contact.socials << test_facebook
      #@contact.save
    #end

    #@products = Product.find(:all)
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
  
  def multipledelete
    ids = params[:sent]
    array = ids.split(",")
    @output = []
    array.each do |id|
      @contact = Contact.find(id)      
      if @contact.is_user == false
	@output << @contact.name
        @contact.destroy
      end
    end
    #@contacts = Contact.where(:user_id => current_user.id)
    
    respond_to do |format|
      format.json { render json: @output, status: :created, location: @contact }
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
    @do_contact_save = false
    @master_contact = Contact.find(master_id)
    ids.each do |id|
      @contact = Contact.find(id) 
      @phones = Phone.where(:contact_id => id)
      @phones.each do |model|
        text = model.number
	type = model._type
	parent_id = model.parent_id
	@master_contact.phones.create!(
	  :_type => type,
	  :number => text,
	  :parent_id => parent_id
	)
      end
      @emails = Email.where(:contact_id => id)
      @emails.each do |model|
        text = model.text
	type = model._type
	parent_id = model.parent_id
	@master_contact.emails.create!(
	  :_type => type,
	  :text => text,
	  :parent_id => parent_id
	)
      end
      @addresses = Address.where(:contact_id => id)
      @addresses.each do |model|
        text = model.full_address
	type = model._type
	parent_id = model.parent_id
	@master_contact.addresses.create!(
	  :_type => type,
	  :full_address => text,
	  :parent_id => parent_id
	)
      end
      @urls = Url.where(:contact_id => id)
      @urls.each do |model|
        text = model.text
	type = model._type
	parent_id = model.parent_id
	@master_contact.urls.create!(
	  :_type => type,
	  :text => text,
	  :parent_id => parent_id
	)
      end
      @notes = Note.where(:contact_id => id)
      @notes.each do |model|
        text = model.text
	type = model._type
	@master_contact.notes.create!(
	  :_type => type,
	  :text => text
	)
      end
      @positions = Position.where(:contact_id => id)
      @positions.each do |model|
        title = model.title
	company = model.company
	type = model._type
	parent_id = model.parent_id
	@master_contact.positions.create!(
	  :_type => type,
	  :title => title,
	  :company => company,
	  :parent_id => parent_id
	)
      end
      if @contact.current_position
        if @master_contact.current_position
	else
	  @master_contact.current_position = @contact.current_position
	  @do_contact_save = true
	end
      end
      if @contact.current_company
        if @master_contact.current_company
	else
	  @master_contact.current_company = @contact.current_company
	  @do_contact_save = true
	end
      end
      @educations = Education.where(:contact_id => id)
      @educations.each do |model|
        title = model.title
	year = model.year
	type = model._type
	parent_id = model.parent_id
	@master_contact.educations.create!(
	  :_type => type,
	  :title => title,
	  :year => year,
	  :parent_id => parent_id
	)
      end
      if @contact.avatar
        if @master_contact.avatar
	else
	  @master_contact.avatar = @contact.avatar
	  @do_contact_save = true
	end
      end
      if @contact.facebook_id
        if @master_contact.facebook_id
	else
	  @master_contact.facebook_id = @contact.facebook_id
	  @master_contact.facebook_handle = @contact.facebook_handle
	  @master_contact.facebook_picture = @contact.facebook_picture
	  @do_contact_save = true
	end
      end
      if @contact.twitter_id
        if @master_contact.twitter_id
	else
	  @master_contact.twitter_id = @contact.twitter_id
	  @master_contact.twitter_handle = @contact.twitter_handle
	  @master_contact.twitter_picture = @contact.twitter_picture
	  @do_contact_save = true
	end
      end
      if @contact.linkedin_id
        if @master_contact.linkedin_id
	else
	  @master_contact.linkedin_id = @contact.linkedin_id
	  @master_contact.linkedin_handle = @contact.linkedin_handle
	  @master_contact.linkedin_picture = @contact.linkedin_picture
	  @do_contact_save = true
	end
      end
      if @contact.is_ripple == true
        if @master_contact.is_ripple == true
        else
	  @master_contact.is_ripple = true
	  @master_contact.linked_contact_id = @contact.linked_contact_id
	  @do_contact_save = true
        end 
      end
      if @contact.is_user == false
	#@output << @contact.name
        @contact.destroy
      end
    end
    if @do_contact_save == true
      @master_contact.save
    end
    #@contacts = Contact.where(:user_id => current_user.id)
    
    respond_to do |format|
      format.json { render json: ids, status: :created, location: @contact }
    end
  end
  


end
