class Device::ServiceUploadPresenter < BasePresenter
  def file_identifier
    h.link_to(super, file_url)
  end
end
