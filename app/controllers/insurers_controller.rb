class InsurersController < ApplicationController
  # GET /insurers
  # GET /insurers.json
  def index
    @insurers = Insurer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @insurers }
    end
  end

  # GET /insurers/1
  # GET /insurers/1.json
  def show
    @insurer = Insurer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @insurer }
    end
  end

  # GET /insurers/new
  # GET /insurers/new.json
  def new
    @insurer = Insurer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @insurer }
    end
  end

  # GET /insurers/1/edit
  def edit
    @insurer = Insurer.find(params[:id])
  end

  # POST /insurers
  # POST /insurers.json
  def create
    @insurer = Insurer.new(params[:insurer])

    respond_to do |format|
      if @insurer.save
        format.html { redirect_to @insurer, notice: 'Insurer was successfully created.' }
        format.json { render json: @insurer, status: :created, location: @insurer }
      else
        format.html { render action: "new" }
        format.json { render json: @insurer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /insurers/1
  # PUT /insurers/1.json
  def update
    @insurer = Insurer.find(params[:id])

    respond_to do |format|
      if @insurer.update_attributes(params[:insurer])
        format.html { redirect_to @insurer, notice: 'Insurer was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @insurer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /insurers/1
  # DELETE /insurers/1.json
  def destroy
    @insurer = Insurer.find(params[:id])
    @insurer.destroy

    respond_to do |format|
      format.html { redirect_to insurers_url }
      format.json { head :ok }
    end
  end
end
