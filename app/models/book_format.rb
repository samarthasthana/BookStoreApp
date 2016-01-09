class BookFormat < ActiveRecord::Base
  validates :book_id, :presence => true
  validates :book_format_type_id, :presence => true 
end
