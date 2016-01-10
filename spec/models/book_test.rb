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
end
