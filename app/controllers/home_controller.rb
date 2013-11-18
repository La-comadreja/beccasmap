class HomeController < ApplicationController
  def index
    @places = locations
    @locs = []
    for j in 0..@places.length
      @loc = @places[j].to_s.split(", ")
      if @loc.length > 1
        @locs.push(@loc[1] + ", New York")
      end
    end
    gon.locs(@locs)
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
    if @i > -1
      return @places[0..@i]
    end
    0
  end
end
