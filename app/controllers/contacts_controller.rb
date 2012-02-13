class ContactsController < ApplicationController
  # GET /contacts
  # GET /contacts.json
  def index
    if params[:search]
      @contacts = Contact.where(:name => /#{params[:search]}/i)
    else
      @contacts = Contact.all
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])
    @products = Product.find(:all)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new

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
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { head :ok }
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
    contacts = Contact.where(:name => /#{params[:term]}/i)
    list = contacts.map {|u| Hash[ id: u.id, label: u.name, name: u.name]}
    #render json: list
    render :json => list.to_json
  end
end
