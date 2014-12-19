class Home < ActiveRecord::Base
  attr_accessible :html, :lastview, :lastview_changed_at
  
  def self.weekly_info
    @time = Time.now.utc
    doc_string = ""
    if Home.last
      doc_string = Home.last.html
      @savedtime = Home.last.lastview
      Home.last.destroy if (@time.to_date - @savedtime.to_date).round != 0 || @time.hour - @savedtime.hour != 0
    else
      doc_string = Nokogiri::HTML(open(URI.escape("http://www.garysguide.com/events.html"))).to_s
      @home = Home.new
      @home.html = doc_string
      @home.lastview = @time
      @home.save
    end

    page = Nokogiri::HTML(doc_string)
    @sections = page.css(".boxx")
    @sections.each do |s|
      return s if s.to_s.include? "<td align=\"center\" width=\"25\""
    end
    return nil
  end
end
