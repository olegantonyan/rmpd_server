class MediaItem::DestroyMultiple
  include ActiveModel::Model

  def self.policy_class
    MediaItemPolicy
  end

  attr_accessor :media_items

  validates :media_items, presence: true

  def destroy
    return false unless valid?
    ActiveRecord::Base.transaction do
      media_items.each do |i|
        i.destroy!
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.to_s)
    false
  end

end
