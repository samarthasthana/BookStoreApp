require 'rails_helper'
require 'spec_helper'

describe Book do
  describe "book model attirbutes" do
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
  end


  describe "#search" do
    describe "when no query string is provided" do
      it "returns an empty array" do
        expect(Book.search(nil)).to eq([])
      end
    end
    describe "when a query string is provided" do
      describe "and title_only option is true" do
        before(:all) do
          FactoryGirl.create(:book, title: "My life and works")
          FactoryGirl.create(:book, title: "Life of others")
          FactoryGirl.create(:book, title: "To live the life.")
          FactoryGirl.create(:book, title: "Batman Vs Superman")
          bookFirst = Book.find_by(:title => "Life of others")
          bookSecond = Book.find_by(:title => "My life and works")
          FactoryGirl.create(:book_review, :book_id => bookFirst.id, :rating => 5)
          FactoryGirl.create(:book_review, :book_id => bookSecond.id, :rating => 3)
          @results = Book.search("life",{ title_only: true })
        end

        it "returns search results for title only" do
          expect(@results.size).to eq(3)
        end

        it "returns search results sorted according to average rating" do
          expect(@results.first.title).to eq("Life of others")
          expect(@results.second.title).to eq("My life and works")
        end

        after(:all) do
          Book.delete_all
          BookReview.delete_all
        end
      end

      describe "and title_only option is false" do
        before(:all) do
          author = FactoryGirl.create(:author, last_name: "Door")
          publisher = FactoryGirl.create(:publisher, name: "Door")
          FactoryGirl.create(:book, title: "The Author", author_id: author.id)
          FactoryGirl.create(:book, title: "The Publisher", publisher_id: publisher.id)
          @book_one = FactoryGirl.create(:book, title: "The Door")
          @book_second = FactoryGirl.create(:book, title: "Random other book")
        end
        describe "and other options are nil " do
          it "returns combined results" do
            expect(Book.search("Door").size).to eq(3)
          end
        end

        describe "when book_format_type_id is provided" do
          it "gives results with only the provided book format" do
            format_type1 = FactoryGirl.create(:book_format_type, name: "Kindle", physical: false)
            format_type2 = FactoryGirl.create(:book_format_type, name: "PDF", physical: false)
            FactoryGirl.create(:book_format, book_id: @book_one.id, book_format_type_id: format_type1.id)
            FactoryGirl.create(:book_format, book_id: @book_second.id, book_format_type_id: format_type2.id)
            result = Book.search("Door", {book_format_type_id: format_type1.id})
            expect(result.size).to eq(1)
            expect(result.first.title).to eq("The Door")
          end
        end

        describe "when book_format_physical is true" do
          it "gives results which have a physical format in the system" do
            format_type1 = FactoryGirl.create(:book_format_type, name: "Paperback", physical: true)
            format_type2 = FactoryGirl.create(:book_format_type, name: "PDF", physical: false)
            FactoryGirl.create(:book_format, book_id: @book_one.id, book_format_type_id: format_type1.id)
            FactoryGirl.create(:book_format, book_id: @book_second.id, book_format_type_id: format_type2.id)
            result = Book.search("Door", {book_format_physical: true})
            expect(result.size).to eq(1)
            expect(result.first.title).to eq("The Door")
            result = Book.search("Door", {book_format_physical: false})
            expect(result.size).to eq(0)
          end
        end

        describe "when book_format_physical is true and book_format_type_id is provided" do
          it "gives results which have a physical format in the system" do
            format_type = FactoryGirl.create(:book_format_type, name: "Paperback", physical: true)
            FactoryGirl.create(:book_format, book_id: @book_one.id, book_format_type_id: format_type.id)
            result = Book.search("Door", {book_format_type_id: format_type.id, book_format_physical: true})
            expect(result.size).to eq(1)
            expect(result.first.title).to eq("The Door")
          end
        end

        after(:all) do
          Book.delete_all
          Author.delete_all
          Publisher.delete_all
          BookFormatType.delete_all
          BookFormat.delete_all
        end
      end
    end
  end

  describe "#author_name" do
    describe "when an invalid author id is used" do
      it "returns nil" do
        expect(FactoryGirl.build(:book, author_id: 0).author_name).to eq(nil)
      end
    end

    describe "when a valid author id is used" do
      it "returns the author name in correct format" do
        author = FactoryGirl.create(:author)
        expect(FactoryGirl.create(:book, author_id: author.id).author_name).to eq("#{author.last_name},#{author.first_name}")
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
        expect(FactoryGirl.build(:book, id: 0).book_format_types).to eq([])
      end
    end

    describe "when book id is valid " do
      before(:all) do
        @book = FactoryGirl.create(:book)
      end
      describe "and there are no formats defined" do
        it "returns an empty array" do
          expect(@book.book_format_types).to eq([])
        end
      end

      describe "and there are valid formats defined" do
        it "returns the formats in an array" do
          formats = []
          book_formats = []
          format_names = []

          3.times { formats << FactoryGirl.create(:book_format_type) }
          formats.each do |f|
            book_formats << FactoryGirl.create(:book_format, book_id: @book.id, book_format_type_id: f.id)
            format_names << f.name
          end
          expect(@book.book_format_types).to eq(format_names)
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
      2.times { FactoryGirl.create(:book_review, :book_id =>12, :rating =>3)}
      1.times { FactoryGirl.create(:book_review, :book_id =>12, :rating =>5)}
    end
    describe "when no review exist for a book" do
      it "returns 0.0 as rating" do
        expect(FactoryGirl.build(:book, :id => 15).average_rating).to eq(0.0)
      end
    end

    describe "when reviews exist for a book" do
      it "gives the correct average rating" do
        expect(FactoryGirl.build(:book, :id => 12).average_rating).to eq(3.7)
      end
    end
    after(:all) do
      BookReview.delete_all
    end
  end

end
