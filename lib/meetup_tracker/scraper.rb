require 'nokogiri'
require 'open-uri'
require 'yaml'

module MeetupTracker
  class Scraper
    DATE = Time.new.strftime("%Y-%m-%d")
    DATE_FILE = File.join(File.dirname(__FILE__), "..", "..", "data", "#{DATE}.yaml")
    URL = "http://atheists.meetup.com/all"
    attr_reader :groups

    def initialize
      @date = DATE
      build_groups
      save
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

    def save
      open(DATE_FILE, 'w') { |f| YAML.dump(@groups, f) }
    end
    
  end
end
