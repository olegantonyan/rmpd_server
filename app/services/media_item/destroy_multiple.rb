class MediaItem
  class DestroyMultiple < BaseService
    attr_accessor :media_items

    validates :media_items, presence: true

    # rubocop: disable Metrics/MethodLength
    def destroy
      return false unless valid?
      ActiveRecord::Base.transaction do
        media_items.each(&:destroy!)
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, e.to_s)
      false
    rescue ActiveRecord::InvalidForeignKey
      errors.add(:base, 'cannot delete items associated with playlist')
      false
    end
    # rubocop: enable Metrics/MethodLength

    def to_s
      media_items.map(&:to_s).to_sentence
    end
  end
end
