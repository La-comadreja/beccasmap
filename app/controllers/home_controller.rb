class HomeController < ApplicationController
  def index
  end

  def locations
    page = Nokogiri::HTML(open("app/views/home/garysguide.html")) 
    @dates = page.css(".boxx")
    @cal = "THIS DOESNT WORK"
    
    @dates.each do |d|
      if d.to_s.include? "Week of"
        @cal = d
        break
      end
    end
  end
end
