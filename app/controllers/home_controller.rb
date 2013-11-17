class HomeController < ApplicationController
  def index
  end

  def locations
    page = Nokogiri::HTML(open(URI.escape("http://www.garysguide.com/events")))
  end
end
