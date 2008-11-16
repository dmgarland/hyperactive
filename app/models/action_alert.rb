# A mini-article-like class to quickly notify site users in emergency situations.
#
class ActionAlert < ActiveRecord::Base
  
  validates_presence_of :summary
  validates_length_of :summary, :maximum => 255
  
  def description
    self.summary.gsub(/<[^>]*>/, '').slice(0..140) 
  end
  
  def title
    "Alert"
  end
  
end
