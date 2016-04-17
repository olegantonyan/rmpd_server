class CompanyPresenter < BasePresenter
  def devices
    h.collection_links(super, :name, :device_path)
  end

  def users
    h.collection_links(super, :to_s, :user_path)
  end
end
