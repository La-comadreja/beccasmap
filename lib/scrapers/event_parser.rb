require 'active_support/all'
require 'rubygems'

module Scrapers
  FREE = "Free"
  LOCATION_SPLIT = ", "
  TBD = "TBD"
  TO_BE_DECIDED = "To be decided"

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

  def self.add_city_state_nycarea(location)
    addr = location.split(LOCATION_SPLIT)
    if addr.length > 1
      city = addr.last.strip
      if city.include? BRONX or city.include? BROOKLYN or city.include? STATEN_ISLAND
        state = NY
      elsif city.include? QUEENS or city.include? JAMAICA or city.include? LONG_ISLAND_CITY
        state = NY
      elsif city.include? HUNTER
        state = NY
      elsif city.include? HOBOKEN or city.include? JERSEY_CITY
        state = NJ
      else
        state = "#{MANHATTAN}, #{NY}"
      end
    elsif addr.first.strip.casecmp(TO_BE_DECIDED) == 0 or addr.first.strip.casecmp(TBD) == 0
      return nil
    elsif addr.first.include? HUNTER
      state = NY
    else
      state = "#{MANHATTAN}, #{NY}"
    end
    "#{location.strip}, #{state}"
  end

  def self.datetime_no_year(section)
    datetime = DateTime.parse(section)
    datetime += 1.year if datetime.mon < Date.current.mon
    datetime
  end

  def self.price_one_currency(section)
    price = section.text.gsub(/\D/,'').to_f
    price = nil if price == 0 and section.text.strip.casecmp(FREE) != 0
    price
  end
end