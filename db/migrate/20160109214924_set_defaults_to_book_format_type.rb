class SetDefaultsToBookFormatType < ActiveRecord::Migration
  def change
    change_column_default :book_format_types, :physical, false
  end
end
