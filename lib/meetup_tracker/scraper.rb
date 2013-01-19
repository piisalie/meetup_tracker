require 'nokogiri'
require 'open-uri'

module MeetupTracker
  class Scraper
    URL = "http://atheists.meetup.com/all"
    attr_reader :groups

    def initialize
      time = Time.new
      @date = time.strftime("%Y-%m-%d")
    end
    
    def scrape
      @page         = Nokogiri::HTML(open(URL))
      @names        = @page.css("li.vcard a").map { |link| link.text }
      @urls         = @page.css("li.vcard a").map { |link| link['href'] }
      @members      = @page.css("li.vcard span.note").map { |note| note.text }
      @member_count = @members.map { |string| /\d+/.match(string)[0] }
    end

    def build_groups
      scrape
      @groups = []
      (0..@names.length).each { |i|
        group = Group.new(@names[i], @urls[i])
        group.add_member_count(@date, @member_count[i])
        @groups << group }
    end    
  end
end
