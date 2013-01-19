module MeetupTracker
  class Group
    def initialize(name, url)
      @name = name
      @url  = url
      @membership = {}
    end

    def add_member_count(date, member_count)
      @membership[date] = member_count
    end

  end
end
