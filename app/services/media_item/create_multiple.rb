class MediaItem::CreateMultiple < BaseService
  def self.policy_class
    MediaItemPolicy
  end

  attr_accessor :description, :company_id, :type, :skip_volume_normalization
  attr_reader :files

  validates :files, presence: true

  def initialize(*args)
    super
    self.description ||= ''
    self.type ||= MediaItem.types.key(0)
  end

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      files.each do |file|
        MediaItem.create!(description: description, company_id: company_id, type: type_indifferent, file: file, skip_volume_normalization: skip_volume_normalization)
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.to_s)
    false
  end

  def files=(arg)
    @files = arg.reject(&:blank?)
  end

  private

  def type_indifferent
    if type.is_a? String
      type
    else
      MediaItem.types.key(type.to_i)
    end
  end
end
