module ValidatesHasManyWithErrorMessages
  extend ActiveSupport::Concern

  included do
    def self.validates_has_many_with_error_messages attr
      instance_exec(attr) do |_attr|
        after_validation do
          public_send(_attr).select{|i| i.invalid? }.each{|i| errors.add(_attr, i.errors.full_messages.to_sentence) }
        end
      end
    end
  end
end
