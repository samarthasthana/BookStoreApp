class SetDefaultToBookReview < ActiveRecord::Migration
  def change
    change_column_default :book_reviews, :rating, 1
  end
end
