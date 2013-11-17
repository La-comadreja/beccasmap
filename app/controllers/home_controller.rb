class HomeController < ApplicationController
  def index
  end

  def locations
    page = Nokogiri::HTML(open("app/views/home/garysguide.html"))
    #page = Nokogiri::HTML(open(URI.escape("http://www.garysguide.com/events")))
 
    @dates = page.css(".boxx") 
    @locations = page.css(".freg")
  end
end
