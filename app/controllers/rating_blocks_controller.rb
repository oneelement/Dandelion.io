class RatingBlocksController < ApplicationController

  def index
    @rating_blocks = RatingBlock.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
    @rating_block = RatingBlock.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

end
