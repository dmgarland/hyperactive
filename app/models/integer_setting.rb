class IntegerSetting < Setting
  
  validates_presence_of :integer_value
  

  def value
    intger_value
  end
  
  def value=(integer)
    integer_value = integer
  end  
  
end
