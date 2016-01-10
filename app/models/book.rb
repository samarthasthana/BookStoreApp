class Book < ActiveRecord::Base
  validates :title, :presence => true
  validates :publisher_id, :presence => true
  validates :author_id, :presence => true

#  attr_accessor :id

  def book_format_types
    # Find the book format the book is available in
    availableTypes = BookFormat.where(:book_id => self.id).map do |format|
      BookFormatType.find(format.book_format_type_id).name
    end
    availableTypes.uniq
  end

  def author_name
    @author = Author.find_by_id(self.author_id)
    unless @author.nil?
      return "#{@author.last_name},#{@author.first_name}"
    end
  end

  def average_rating
    @sum = 0.0
    @reviews = BookReview.where(:book_id => self.id).to_a
    unless @reviews.empty?
      @reviews.each { |rev| @sum += rev.rating }
      return (@sum/ @reviews.size).round(1)
    end
  end
end
