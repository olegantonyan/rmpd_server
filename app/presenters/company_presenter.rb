class CompanyPresenter < BasePresenter
  def users
    super.map(&:to_s).to_sentence
  end

  def devices
    h.collection_links(super, :name, :device_path)
  end
end
