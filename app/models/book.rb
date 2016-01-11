class Book < ActiveRecord::Base
  validates :title, :presence => true
  validates :publisher_id, :presence => true
  validates :author_id, :presence => true

#  attr_accessor :id

  def book_format_types
    # Find the book format the book is available in
    (BookFormat.where(:book_id => self.id).map { |f| BookFormatType.find(f.book_format_type_id).name }).uniq
  end

  def author_name
    author = Author.find_by_id(self.author_id)
    unless author.nil?
      return "#{author.last_name},#{author.first_name}"
    end
  end

  def average_rating
    sum = 0.0
    rating = 0.0
    reviews = BookReview.where(:book_id => self.id).to_a
    unless reviews.empty?
      reviews.each { |rev| sum += rev.rating }
      rating = (sum/ reviews.size).round(1)
    end
    rating
  end

  def self.search(query, options = {title_only: false, book_format_type_id: nil, book_format_physical: nil })
    combined_results = []
    unless query.nil?
      author_results = []
      publisher_results = []
      title_results = self.where("lower(title) like ?","%#{query.downcase}%").to_a
      if options[:title_only]
        # Returning results just for title search in desc order of rating
        return (title_results.uniq).sort_by { |b| -b.average_rating }
      end
      # Getting results based on author last_name
      Author.where("lower(last_name) = ?", query.downcase).each { |a| author_results += Book.where("author_id = ?", a.id) }
      # Getting results based on publisher name
      Publisher.where("lower(name) = ?", query.downcase).each { |p| publisher_results += Book.where("publisher_id = ?", p.id) }
      # Combining the result arrays and soring by average rating in Desc order
      combined_results = ((author_results + publisher_results + title_results).uniq).sort_by { |b| -b.average_rating }

      unless options[:book_format_type_id].nil? and options[:book_format_physical].nil?
        physical_formats = []
        if options[:book_format_physical]
          BookFormatType.where(:physical => true).each {|bft| physical_formats << bft.id}
        else
          physical_formats << options[:book_format_type_id]
        end
        combined_results.reject! {|b| BookFormat.where(:book_id => b.id, :book_format_type_id => physical_formats).empty?}
      end
    end
    combined_results
  end
end
