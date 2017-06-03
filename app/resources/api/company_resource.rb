module Api
  class CompanyResource < Api::BaseResource
    attributes :title

    has_many :users
    has_many :devices
    has_many :playlists
    has_many :media_items
  end
end
