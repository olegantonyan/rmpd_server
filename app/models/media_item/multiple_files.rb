class MediaItem::MultipleFiles
  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self)
  end

  attr_accessor :description, :company_id, :type, :files

  validates :files, presence: true

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      files.each do |file|
        sap MediaItem.create!(description: description, company_id: company_id, type: type, file: file)
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.to_s)
    false
  end

  def destroy
  end

end
