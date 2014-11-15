class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]
  
  # GET /playlists
  def index
    @playlists = Playlist.all
  end

  # GET /playlists/1
  def show
    @media_items_in_playlist = MediaItem.in_playlist_ordered(params[:id])
  end
  
  # GET /playlists/new
  def new
    @playlist = Playlist.new
    @media_items = MediaItem.all
    @media_deployments = MediaDeployment.all
  end
  
  # GET /playlists/1/edit
  def edit
    @media_items = MediaItem.all
  end

  # POST /playlists
  def create
    @playlist = Playlist.new(playlist_params)
    media_items = MediaItem.find(params[:media_items_ids])
    media_items.each do |i|
      media_deployment = MediaDeployment.new
      media_deployment.media_item = i
      media_deployment.playlist_position = params["media_item_position#{i.id}"]
      @playlist.media_deployments << media_deployment
      puts "#########"
      puts @playlist.media_deployments.inspect
      puts "#########"
    end
    
    respond_to do |format|
      if @playlist.save
        flash_success 'Playlist was successfully created'
        format.html { redirect_to @playlist }
      else
        flash_error 'Error creating playlist'
        @media_items = MediaItem.all
        format.html { render :new }
      end
    end
  end
  
  # PATCH/PUT /playlists/1
  def update
    @playlist.name = params[:playlist][:name]
    @playlist.description = params[:playlist][:description]
    media_items = MediaItem.find(params[:media_items_ids])
    @playlist.media_deployments.clear
    media_items.each do |i|
      media_deployment = MediaDeployment.new
      media_deployment.media_item = i
      media_deployment.playlist_position = params["media_item_position#{i.id}"]
      @playlist.media_deployments << media_deployment
    end
    
    respond_to do |format|
      if @playlist.save
        flash_success 'Playlist was successfully updated'
        format.html { redirect_to @playlist }
      else
        flash_error = 'Error updating playlist'
        format.html { render :edit }
      end
    end
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
    
end
