class MainMenu < ApplicationModel
  attr_accessor :user

  class << self
    def items
      %i[media_items playlists devices device_groups companies users]
    end
  end

  attr_accessor(*items)

  def initialize(*args)
    super
    self.class.items.each do |i|
      policy = policy_by_item(i)
      send("#{i}=", policy.index?)
    end
  end

  def to_hash
    self.class.items.each_with_object({}) do |e, a|
      a[e] = send(e)
    end
  end

  private

  def policy_by_item(i)
    arg = case i
          when :device_groups
            Device::Group
          else
            i.to_s.singularize.to_sym
          end
    Pundit.policy!(user, arg)
  end
end
