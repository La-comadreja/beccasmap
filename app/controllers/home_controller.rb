class HomeController < ApplicationController
  def index
  end

  def locations
    page = Nokogiri::HTML(open("app/views/home/garysguide.html")) 
    @dates = page.css(".boxx")
    @cal = "Week of"
    
    @dates.each do |d|
      cal = d if d.include? "Week of"
    end
  end
end
