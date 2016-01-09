class Book < ActiveRecord::Base
  validates :title, :presence => true
  validates :publisher_id, :presence => true
  validates :author_id, :presence => true
end
