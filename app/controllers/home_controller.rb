class HomeController < ApplicationController
  def index
  end

  def locations
    page = Nokogiri::HTML(open("app/views/home/garysguide.html")) 
    @sections = page.css(".boxx")
    @day = "THIS DOESNT WORK"
    
    @sections.each do |s|
      if s.to_s.include? "Week of"
        @day = s.to_s.split("<font class=\"flarge\"><b>")[2]
        break
      end
    end
  end
end
