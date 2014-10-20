class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]
  before_action :set_active_menu_item
  
  # GET /playlists
  def index
    @playlists = Playlist.all
  end

  # GET /playlists/1
  def show
    @media_items_in_playlist = MediaItem.joins(:media_deployments)
          .where(:media_deployments => {:playlist => Playlist.find(params[:id])})
          .order('media_deployments.playlist_position')
  end
  
  # GET /playlists/new
  def new
    @playlist = Playlist.new
    @media_items = MediaItem.all
  end
  
  # GET /playlists/1/edit
  def edit
    #@playlist = Playlist.find(params[:id])
    @media_items = MediaItem.all
  end

  # POST /playlists
  def create
    @playlist = Playlist.new(playlist_params)
    respond_to do |format|
      if @playlist.save
        flash_success 'Playlist item was successfully created'
        format.html { redirect_to @playlist }
      else
        flash_error = 'Error creating playlist'
        format.html { render :new }
      end
    end
  end
  
  # PATCH/PUT /playlists/1
  def update
  end
  
  # DELETE /playlists/1
  def destroy
    @playlist.destroy
    respond_to do |format|
      flash_success 'Playlist was successfully deleted'
      format.html { redirect_to playlists_url }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:name, :description)
    end
    
    def set_active_menu_item
      @active_playlists = "active"
    end
end
