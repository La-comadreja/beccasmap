class HomeController < ApplicationController
  def index
    @places = locations
    @locs = []
    for j in 0..@places.length
      p = @places[j].to_s.split(", ")
      if p.length > 1
        boro = ", New York"
        if p.length > 2
          boro = ", Brooklyn" + boro if p[p.length - 1].include? "Brooklyn"
          boro = ", Manhattan" + boro if p[p.length - 1].include? "Manhattan"
          boro = ", Queens" + boro if p[p.length - 1].include? "Queens"
          boro = ", Bronx" + boro if p[p.length - 1].include? "Bronx"
          boro = ", Hoboken, New Jersey" if p[p.length - 1].include? "Hoboken"
        end
        @locs.push(p[1].split("</font>")[0] + boro)
      end
    end
    gon.locs = @locs
  end

  def locations
    s = weekly_info
    @days = s.to_s.split("<font class=\"flarge\"><b>")
    @days.each do |d|
      if d.include? "<td align=\"center\" width=\"25\""
        @day = d
        break
      end
    end
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
    @time = Time.now.utc
    doc_string = ""
    if Home.last
      doc_string = Home.last.html
      @savedtime = Home.last.lastview
      @daysbetween = (@savedtime.to_date - @time.to_date).floor
      Home.last.destroy if @daysbetween > 1 || (@daysbetween == 1 && @time.hour >= 3) || (@savedtime.hour < 3 && @time.hour >= 3)
    else
      doc_string = Nokogiri::HTML(open(URI.escape("http://www.garysguide.com/events.html"))).to_s
      @home = Home.new
      @home.html = doc_string
      @home.lastview = @time
      @home.save
      doc_string =
    end

    page = Nokogiri::HTML(doc_string)
    @sections = page.css(".boxx")
    @sections.each do |s|
      return s if s.to_s.include? "<td align=\"center\" width=\"25\""
    end
    return nil
  end

  def extract(html_string)
    @info = []
    i = 0
    html_string.each do |str|
      s = str.to_s
      if i == 1 or i == -1
        if s.include? "<td align=\"center\" valign=\"top\" width=\"48\">"
          @info.push(s)
        elsif s.include? "<font class=\"freg\">" and !s.include? ", "
          @info.pop
          i = -1
        elsif s.include? "<hr style=\"border:0; color:"
          i = 1
        elsif s.include? "width=\"100%\"" or s.include? "<font class=\"flarge\"><b>" or s.include? "<td align=\"left\" colspan=\"7\" class=\"fsmall\">"
        elsif @info.length > 0 && i == 1
          if !s["><b>"].nil?
            s["><b>"] = " target=\"_blank\"><b>"
          end
          @info[@info.length-1] += s
        end
      end
      i += 1 if s.include? "<td align=\"left\" colspan=\"7\"><font class=\"flarge\">"
    end
    gon.info = @info
  end
end
