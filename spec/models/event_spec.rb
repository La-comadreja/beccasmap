require 'rails_helper'

describe Event do
  before(:each) do
    @event = FactoryGirl.build(:event)
    expect(@event).to be_valid
  end
  
  it "requires a category" do
    @event.category = nil
    expect(@event).to be_invalid
  end
  
  it "requires a datetime" do
    @event.datetime = nil
    expect(@event).to be_invalid
  end
  
  it "requires a name" do
    @event.name = nil
    expect(@event).to be_invalid
  end
  
  it "allows venue to be nil" do
    @event.venue = nil
    expect(@event).to be_valid
  end
  
  it "requires an address" do
    @event.address = nil
    expect(@event).to be_invalid
  end
  
  it "requires a link" do
    @event.link = nil
    expect(@event).to be_invalid
  end
  
  it "allows price to be nil" do
    @event.price = nil
    expect(@event).to be_valid
  end
  
  it "allows description to be nil" do
    @event.description = nil
    expect(@event).to be_valid
  end
end