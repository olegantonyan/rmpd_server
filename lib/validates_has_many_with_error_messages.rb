module ValidatesHasManyWithErrorMessages
  extend ActiveSupport::Concern

  included do
    def self.validates_has_many_with_error_messages(attr)
      instance_exec(attr) do |a_attr|
        after_validation do
          public_send(a_attr).select(&:invalid?).each { |i| errors.add(a_attr, i.errors.full_messages.to_sentence) }
        end
      end
    end
  end
end
