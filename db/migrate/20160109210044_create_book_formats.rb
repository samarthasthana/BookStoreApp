class CreateBookFormats < ActiveRecord::Migration
  def change
    create_table :book_formats do |t|
      t.integer :book_id
      t.integer :book_format_type_id

      t.timestamps null: false
    end
  end
end
