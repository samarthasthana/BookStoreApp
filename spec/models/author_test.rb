require 'rails_helper'
require 'spec_helper'

describe Author do
  it "has a valid factory" do
    expect(FactoryGirl.create(:author)).to be_valid
  end
  it "is invalid without a first name" do
    expect(FactoryGirl.build(:author, first_name: nil)).to_not be_valid
  end
  it "is invalid without a last name" do
    expect(FactoryGirl.build(:author, last_name: nil)).to_not be_valid
  end
end
