class HomeController < ApplicationController
  def index
  end

  def locations
    page = Nokogiri::HTML(open("app/views/home/garysguide.html"))
    #page = Nokogiri::HTML(open(URI.escape("http://www.garysguide.com/events")))
 
    @dates = page.css(".boxx") 
    cal = ""
    @dates.each do |d|
      if d.include? "Week of"
        cal = d
        break
      end
    end
  end
end
