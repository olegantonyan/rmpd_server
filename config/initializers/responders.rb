module FlashResponderExtension
  def mount_i18n_options(status) #:nodoc:
    super.merge(errors: resource.errors.full_messages.to_sentence)
  end
end

module Responders
  module FlashResponder
    prepend FlashResponderExtension
  end
end
