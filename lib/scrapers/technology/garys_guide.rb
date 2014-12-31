require_relative '../event_parser'
require_relative '../../../config/environment'

module Scrapers
  module Technology
    class GarysGuide
      CATEGORY_TECHNOLOGY = "Technology"
      CLASS_KEY = "class"
      COL_KEY = "td"
      DATE_FINDER = "flarger"
      DESC_FINDER = "fsmall"
      FONT_KEY = "font"
      HREF_KEY = "href"
      NAME_KEY = "a"
      VENUE_FINDER = "freg"
      WEEK_OF = "Week of"
      WID_KEY = "width"
      WID_PRICE = "37"
      WID_TIME = "48"

      def self.scrape
        date = nil
        page = Nokogiri::HTML(open(URI.escape("http://www.garysguide.com/events.html")))
        sections = page.css("div.boxx table table[width=\"100%\"] tr")
        sections.each do |section|
          event = Event.new
          date = parse(section, event)
          name_link = section.css(NAME_KEY)
          event.name = name_link.text
          event.link = name_link.first[HREF_KEY] if name_link.length > 0
          event.category = CATEGORY_TECHNOLOGY
          section.css(COL_KEY).each do |col|
            event.datetime = Scrapers.datetime_no_year("#{date} #{col.text} EST") if col[WID_KEY] == WID_TIME
            event.price = Scrapers.price_one_currency(col) if col[WID_KEY] == WID_PRICE
          end
          event.save
        end
      end

      private
      def self.parse(section, event)
        date = nil
        section.css(FONT_KEY).each do |field|
          case field[CLASS_KEY]
          when DATE_FINDER
            date = field.text if !field.text.include? WEEK_OF
          when VENUE_FINDER
            location = field.text.split(LOCATION_SPLIT, 2)
            event.venue = location.first.strip
            event.address = Scrapers.add_city_state_nycarea(location.last.strip) if location.length > 1
          when DESC_FINDER
            event.description = field.text
          end
        end
        date
      end
      private_class_method :parse
    end
  end
end

Scrapers::Technology::GarysGuide.scrape