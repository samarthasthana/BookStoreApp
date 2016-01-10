class BookReview < ActiveRecord::Base
  validates :rating, inclusion: 1..5, :presence => true
  validates :book_id, :presence => true
end
