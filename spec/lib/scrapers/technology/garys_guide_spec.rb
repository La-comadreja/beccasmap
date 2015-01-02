require 'rails_helper'

describe Scrapers::Technology::GarysGuide do
  TEST_FILE = "#{Rails.root}/spec/lib/scrapers/test_data/garys_guide_dec_31_2014.html"

  before(:each) do
    allow(Nokogiri).to receive(:HTML).and_return(Nokogiri::HTML(open(TEST_FILE)))
    allow(Scrapers::Technology::GarysGuide).to receive(:open).and_return(nil)
    Scrapers::Technology::GarysGuide.scrape
  end

  it "saves records" do
    expect(Event.count).to be > 50
  end

  it "retrieves a correct sample record" do
    allow(Time.zone).to receive(:now).and_return(DateTime.parse("2014/12/31 23:00:00 UTC"))
    sample = Event.find_by_name("NYC Tech Breakfast")
    expect(sample.category).to eql("Technology")
    expect(sample.venue).to eql("AOL / HuffPo")
    expect(sample.address).to eql("770 Broadway, 6th Fl, Manhattan, New York")
    expect(sample.datetime.year).to eql(2015)
    expect(sample.datetime.mon).to eql(1)
    expect(sample.datetime.mday).to eql(13)
    expect(sample.datetime.strftime("%H:%M%P %Z")).to eql("08:00am EST")
    expect(sample.link).to eql("http://www.garysguide.com/events/5399itr/NYC-Tech-Breakfast")
    expect(sample.price).to eql(0.0)
    expect(sample.description).to eql("Presentations by Netskope, Advizr, Attopedia, FWD.us NYC and Ziggeo.")
  end
end