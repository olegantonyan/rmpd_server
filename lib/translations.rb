module Translations
  module_function

  def all
    translations = I18n.backend.send(:translations)
    if translations.empty?
      I18n.t('force_load_these_damn_translations')
      translations = I18n.backend.send(:translations)
    end
    translations[I18n.locale]
  end
end
