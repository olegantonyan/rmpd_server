class MediaItem::CreateMultiple < BaseService
  def self.policy_class
    MediaItemPolicy
  end

  attr_accessor :description, :company_id, :type, :files

  validates :files, presence: true

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      files.each do |file|
        MediaItem.create!(description: description, company_id: company_id, type: type_indifferent, file: file)
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.to_s)
    false
  end

  private

  def type_indifferent
    MediaItem.types.key(type.to_i) || type
  end
end
