class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.integer :publisher_id
      t.integer :author_id

      t.timestamps null: false
    end
  end
end
