class AddTranslatorRoleAndPermission < ActiveRecord::Migration
  def self.up
    translate = StaticPermission.new
    translate.title = "translate_ui"
    translate.save!
    
    translator = Role.new
    translator.title = "Translator"
    translator.static_permissions << [translate]
    translator.save! 
  end

  def self.down
    translate = StaticPermission.find_by_title("translate_ui")
    translator = Role.find_by_title("Translator")
    translate.destroy
    translator.destroy
  end
end