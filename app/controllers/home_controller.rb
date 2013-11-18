class HomeController < ApplicationController
  def index
    @places = locations
    @locs = []
    for j in 0..@places.length
      @loc = @places[j].to_s.split(", ")
      if @loc.length > 1
        @locs.push(@loc[1].split("</font>")[0] + ", New York")
      end
    end
    gon.locs = @locs
  end

  def locations
    s = weekly_info
    @day = s.to_s.split("<font class=\"flarge\"><b>")[2]
    extract(s.css("td td"))
    @places = s.css(".freg")
    @i = -1
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
    return [""]
  end

  def weekly_info
    page = Nokogiri::HTML(open("app/views/home/garysguide.html"))
    @sections = page.css(".boxx")
    @sections.each do |s|
      return s if s.to_s.include? "Week of"
    end
    return nil
  end

  def extract(html_string)
    @info = []
    i = 0
    html_string.each do |s|
      if i == 1
        if s.to_s.include? "<td align=\"left\" colspan=\"7\"><hr style=\"border:0; color:"
          @info.push(s.to_s)
        elsif (s.to_s.include? "width=\"100%\"")
        else
          @info[@info.length-1] += s.to_s
        end
      end
      i += 1 if s.to_s.include? "<td align=\"left\" colspan=\"7\"><font class=\"flarge\">"
    end
    gon.info = @info
  end
end
