class Page < ActiveRecord::Base
  validates_uniqueness_of :title
  validates_presence_of :title, :body
end
