class Publisher < ActiveRecord::Base
  validates :name, :presence => true
end
