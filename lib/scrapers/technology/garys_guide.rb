require_relative '../event_parser'
require_relative '../../../config/environment'

class GarysGuide
  CATEGORY_TECHNOLOGY = "Technology"
  CLASS_KEY = "class"
  COL_KEY = "td"
  DATE_FINDER = "flarger"
  DESC_FINDER = "fsmall"
  FONT_KEY = "font"
  HREF_KEY = "href"
  LOCATION_SPLIT = ","
  NAME_KEY = "a"
  VENUE_FINDER = "freg"
  WEEK_OF = "Week of"
  WIDTH_KEY = "width"
  WIDTH_PRICE = "37"
  WIDTH_TIME = "48"

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
        event.datetime = datetime_no_year("#{date} #{col.text} EST") if col[WIDTH_KEY] == WIDTH_TIME
        event.price = price_one_currency(col) if col[WIDTH_KEY] == WIDTH_PRICE
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
        event.address = add_city_state_nycarea(location.last.strip) if location.length > 1
      when DESC_FINDER
        event.description = field.text
      end
    end
    date
  end
  private_class_method :parse
end

GarysGuide.scrape