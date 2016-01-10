require 'rails_helper'
require 'spec_helper'

describe Book do
  it "has a valid factory for book model" do
    expect(FactoryGirl.create(:book)).to be_valid
  end

  it "is invalid without a title" do
    expect(FactoryGirl.build(:book, title: nil)).to_not be_valid
  end

  it "is invalid without a publisher_id" do
    expect(FactoryGirl.build(:book, publisher_id: nil)).to_not be_valid
  end

  it "is invalid without a author_id" do
    expect(FactoryGirl.build(:book, author_id: nil)).to_not be_valid
  end

  describe "#search" do
    describe "when no query string is provided" do
      it "returns a nil" do
        expect(Book.search(nil)).to eq(nil)
      end
    end
    describe "when a query string is provided" do
      let(:query) { "life" }
      describe "when title_only option is true" do
        before(:all) do
          FactoryGirl.create(:book, title: "My life and works")
          FactoryGirl.create(:book, title: "Life of others")
          FactoryGirl.create(:book, title: "To live the life.")
          FactoryGirl.create(:book, title: "Lift the Li fe")
        end

        it "returns search results for title only" do
          @results = Book.search(query,{title_only: true})
          expect(@results.size).to eq(3)
        end
        after(:all) do
          Book.delete_all
        end
      end
    end
  end

  describe "#author_name" do
    describe "when an invalid author id is used" do
      it "returns nil" do
        @book = FactoryGirl.build(:book, author_id: 0)
        expect(@book.author_name).to eq(nil)
      end
    end

    describe "when a valid author id is used" do
      it "returns the author name in correct format" do
        @author = FactoryGirl.create(:author)
        @book = FactoryGirl.create(:book, author_id: @author.id)
        expect(@book.author_name).to eq("#{@author.last_name},#{@author.first_name}")
      end
    end
    after(:all) do
      Book.delete_all
      Author.delete_all
    end
  end

  describe "#book_format_types" do
    describe "when book id is not valid" do

      it "returns an empty array" do
        @book = FactoryGirl.build(:book, id: 0)
        expect(@book.book_format_types).to eq([])
      end
    end

    describe "when book id is valid " do
      before(:all) do
        @book = FactoryGirl.create(:book)
      end
      describe "When there are no formats defined" do
        it "returns an empty array" do
          expect(@book.book_format_types).to eq([])
        end
      end

      describe "when there are valid formats defined" do
        it "returns the formats in an array" do
          @formats = []
          @book_formats = []
          @format_names = []

          3.times { @formats << FactoryGirl.create(:book_format_type) }
          @formats.each do |f|
            @book_formats << FactoryGirl.build(:book_format, book_id: @book.id, book_format_type_id: f.id)
            @format_names << f.name
            f.save
            (@book_formats.last).save
          end
          expect(@book.book_format_types).to eq(@format_names)
        end
      end
      after(:all) do
        Book.delete_all
        BookFormatType.delete_all
        BookFormat.delete_all
      end
    end
  end

  describe "#average_rating" do
    before(:all) do
      4.times { FactoryGirl.create(:book_review, :book_id =>12, :rating =>3)}
    end
    describe "when no review exist for a book" do
      it "returns 0.0 as rating" do
        expect(FactoryGirl.build(:book, :id => 15).average_rating).to eq(0.0)
      end
    end

    describe "when reviews exist for a book" do
      it "gives the correct average rating" do
        expect(FactoryGirl.build(:book, :id => 12).average_rating).to eq(3.0)
      end
    end
    after(:all) do
      BookReview.delete_all
    end
  end

end
