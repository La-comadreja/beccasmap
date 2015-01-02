require 'active_support/all'
require 'rails_helper'

describe Scrapers::EventParser do
  EST = "America/New_York"
  SAMPLE_TIME = "#{Date.current.year}/12/31 23:00:00 EST"

  context "city/state" do
    it "identifies city and state correctly" do
      test_addr = "A, B"
      BRONX = "Bronx"
      BROOKLYN = "Brooklyn"
      HOBOKEN = "Hoboken"
      JAMAICA = "Jamaica"
      JERSEY_CITY = "Jersey City"
      HUNTER = "Hunter"
      LONG_ISLAND_CITY = "Long Island City"
      MANHATTAN = "Manhattan"
      QUEENS = "Queens"
      STATEN_ISLAND = "Staten Island"
      NJ = "New Jersey"
      NY = "New York"
      expect(Scrapers::EventParser.add_city_state_nycarea("#{test_addr}, #{BRONX}")).to end_with NY
      expect(Scrapers::EventParser.add_city_state_nycarea("#{test_addr}, #{BROOKLYN}")).to end_with NY
      expect(Scrapers::EventParser.add_city_state_nycarea("#{test_addr}, #{STATEN_ISLAND}")).to end_with NY
      expect(Scrapers::EventParser.add_city_state_nycarea("#{test_addr}, #{QUEENS}")).to end_with NY
      expect(Scrapers::EventParser.add_city_state_nycarea("#{test_addr}, #{JAMAICA}")).to end_with NY
      expect(Scrapers::EventParser.add_city_state_nycarea("#{test_addr}, #{LONG_ISLAND_CITY}")).to end_with NY
      expect(Scrapers::EventParser.add_city_state_nycarea("#{test_addr}, #{HUNTER}")).to end_with NY
      expect(Scrapers::EventParser.add_city_state_nycarea("#{test_addr}, #{HOBOKEN}")).to end_with NJ
      expect(Scrapers::EventParser.add_city_state_nycarea("#{test_addr}, #{JERSEY_CITY}")).to end_with NJ
      expect(Scrapers::EventParser.add_city_state_nycarea(test_addr)).to end_with "#{MANHATTAN}, #{NY}"
      expect(Scrapers::EventParser.add_city_state_nycarea("TO BE DECIDED")).to be_nil
      expect(Scrapers::EventParser.add_city_state_nycarea("TBD")).to be_nil
      expect(Scrapers::EventParser.add_city_state_nycarea(HUNTER)).to end_with NY
      expect(Scrapers::EventParser.add_city_state_nycarea("A")).to end_with "#{MANHATTAN}, #{NY}"
    end
  end

  context "datetime" do
    before(:each) do
      allow(Time.zone).to receive(:now).and_return(DateTime.parse(SAMPLE_TIME))
    end

    it "parses a datetime" do
      datetime = Scrapers::EventParser.datetime_noyr("Wednesday, Dec 31 09:00 PM EST",EST)
      expect(datetime).to eql(DateTime.parse("#{Date.current.year}/12/31 21:00:00 EST"))
    end

    it "adds a year when the month of the event is earlier than current month" do
      datetime = Scrapers::EventParser.datetime_noyr("Friday, Jan 2 09:00 PM EST",EST)
      expect(datetime).to eql(DateTime.parse("#{Date.current.year + 1}/01/02 21:00:00 EST"))
    end
  end

  context "price" do
    before(:each) do
      @source = Nokogiri::XML::Element.new("test", Nokogiri::HTML::Document.new)
    end

    it "records dollars and cents" do
      @source.content = "17.95"
      expect(Scrapers::EventParser.price_one_currency(@source)).to eq 17.95
    end

    it "recognizes prices with currency signs" do
      @source.content = "$7.50"
      expect(Scrapers::EventParser.price_one_currency(@source)).to eq 7.5
      @source.content = "10.25 EUR"
      expect(Scrapers::EventParser.price_one_currency(@source)).to eq 10.25
    end

    it "recognizes 'free'" do
      @source.content = "free"
      expect(Scrapers::EventParser.price_one_currency(@source)).to eq 0
    end
  end
end