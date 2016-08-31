module MediaItemsHelper
  def show_file_processing_navbar?
    policy_scope(MediaItem.processing).exists?
  end

  def file_processing_navbar_text
    I18n.t('views.media_items.files_processing_navbar', count: MediaItem.processing.count)
  end
end
