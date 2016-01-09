class BookReview < ActiveRecord::Base
  enum rating: [1,2,3,4,5]
  validates :book_id, :presence => true
  validates :rating, :presence => true
end
