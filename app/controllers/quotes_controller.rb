class QuotesController < ApplicationController

    # GET /quotes/new
    # GET /quotes/new.json
    def new
        @quote = Quote.new
        @quote.build_risk

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @quote }
        end
    end

    #POST /quotes
    #POST /quotes.json
    def create
        puts 'HERE NOW'
        puts params[:quote].to_s
        puts 'DONE NOW'
        @quote = Quote.new(params[:quote])

        respond_to do |format|
            if @quote.save
                format.html { redirect_to @quote, notice: 'Quoting...' }
                format.json { render json: @quote, status: created, location: @quote }
            else
                format.html { render action: "new" }
                format.json { render json: @quote.errors, status: :unprocessable_quote }
            end
        end
    end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
    @quote = Quote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

end
