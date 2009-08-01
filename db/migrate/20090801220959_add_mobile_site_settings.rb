class AddMobileSiteSettings < ActiveRecord::Migration
  def self.up
    show_dispatch_number = BooleanSetting.new
    show_dispatch_number.key = "show_dispatch_number_on_mobile_template"
    show_dispatch_number.value = false
    show_dispatch_number.save!

    dispatch_number = StringSetting.new
    dispatch_number.key = "dispatch_number"
    dispatch_number.value = "123456"
    dispatch_number.save!

    mobile_subdomain = StringSetting.new
    mobile_subdomain.key = "mobile_subdomain"
    mobile_subdomain.value = "mob"
    mobile_subdomain.save!
  end

  def self.down

  end
end

