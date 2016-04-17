class UserPresenter < BasePresenter
  def companies
    h.collection_links(super, :to_s, :company_path)
  end
end
