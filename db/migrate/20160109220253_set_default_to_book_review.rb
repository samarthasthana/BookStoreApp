class SetDefaultToBookReview < ActiveRecord::Migration
  def change
    change_column_default :book_reviews, :rating, 0
  end
end
