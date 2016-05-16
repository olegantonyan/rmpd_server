class ActiveModelBase
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  extend ActiveModel::Translation

  def self.create!(attrs)
    new(attrs).save!
  end

  def copy_errors(object)
    object.errors.each do |k, v|
      errors.add(k, v)
    end
  end

  def save!
    raise ActiveRecord::RecordInvalid, self unless save
  end

  def destroy!
    raise ActiveRecord::RecordInvalid, self unless destroy
  end

  def assign_if(output, attr, value)
    output.public_send("#{attr}=", value) if value
  end
end
