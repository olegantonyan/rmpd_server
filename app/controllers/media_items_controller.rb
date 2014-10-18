class MediaItemsController < ApplicationController
  
  before_action :set_media_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @media_items = MediaItem.all
  end

  def show
  end
  
  def new
    @media_item = MediaItem.new
  end
  
  def edit
  end

  def create
    @media_item = MediaItem.new(media_item_params)
    
    respond_to do |format|
      if @media_item.save
        format.html { redirect_to @media_item, notice: 'Media item was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end
  
  def update
  end
  
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_media_item
      @media_item = MediaItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def media_item_params
      params.require(:media_item).permit(:file, :description)
    end
end
