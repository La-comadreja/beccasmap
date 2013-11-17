class HomeController < ApplicationController
  def index
  end

  def locations
    page = Nokogiri::HTML(open("app/views/home/garysguide.html")) 
    @sections = page.css(".boxx")
    @i = -1

    @sections.each do |s|
      if s.to_s.include? "Week of"
        @day = s.to_s.split("<font class=\"flarge\"><b>")[2]
        @places = s.css(".freg")
        break
      end
    end

    @places.each do |p|
      if @day.include? p.to_s
        @i += 1
      else
        break
      end
    end
  end
end
