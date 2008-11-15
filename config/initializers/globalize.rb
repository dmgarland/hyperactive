# Globalize configuration for internationalization purposes
include Globalize
Locale.set_base_language('en-GB')
Locale.set('en-GB')


# NB: there should be no need for anybody to mess with this unless they're really 
# working on the globalize code.
#
# In production mode, this code should load every view translation into memory 
# once from the database when the application starts, avoiding database calls from globalize.
#Dispatcher.to_prepare :globalize_view_translations do
#  if RAILS_ENV == 'production' 
#    translator = Globalize::DbViewTranslator.instance
#      #Or whichever other means used to keep track of app specific supported languages 
#      SupportedLanguage.find(:all).each do |lang|
#        ViewTranslation.find(:all, :conditions => ['globalize_translations.language_id = ?', lang.language_id]).each do |tr|
#          translator.send(:cache_add, tr.tr_key, tr.language, tr.pluralization_index, tr.text)
#        end  
#    end 
#  end
#end