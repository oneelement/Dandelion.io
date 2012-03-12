class ProductVersionsController < ApplicationController
  before_filter :find_product

  def find_product
    @product = Product.find(params[:product_id])
  end

  def show
    @version = ProductVersion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render_for_api :product_version, :json => @version }
    end
  end

  def new
    @version = ProductVersion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  def edit
    @version = ProductVersion.find(params[:id])
  end

  def create
    @version = ProductVersion.new(params[:version])

    respond_to do |format|
      if @version.save
        format.html { redirect_to @version, notice: 'Version was successfully created.' }
        format.json { render json: @version, status: :created, location: @version }
      else
        format.html { render action: "new" }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @version = ProductVersion.find(params[:id])

    respond_to do |format|
      if @version.update_attributes(params[:product_version])
        format.html { redirect_to @version, notice: 'Version was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @version = ProductVersion.find(params[:id])
    @version.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :ok }
    end
  end
end
