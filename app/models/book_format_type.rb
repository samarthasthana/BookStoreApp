class BookFormatType < ActiveRecord::Base
  validates :name, :presence => true 
end
