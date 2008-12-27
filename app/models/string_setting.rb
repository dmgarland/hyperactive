class StringSetting < Setting
  
  validates_presence_of :string_value, :unless => Proc.new { |s| s.key == "home_page_feed" }
  
  def value
    string_value
  end
  
  def value=(new_value)
    self.string_value = new_value
  end
  
  
end
