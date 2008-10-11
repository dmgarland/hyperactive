class Category < ActiveRecord::Base
  validates_presence_of :name, :description
  validates_length_of :name, :minimum=>3
  validates_length_of :description, :minimum=>10
end
