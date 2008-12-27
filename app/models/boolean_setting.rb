class BooleanSetting < Setting
  
  validates_inclusion_of :boolean_value, :in => [true, false]
  
  def value
    boolean_value
  end
  
  def value=(new_value)
    self.boolean_value = new_value
  end
    
end