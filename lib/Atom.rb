require 'open-uri'
require 'atom'

module ImageFeed
  
  def self.parse(src, since=nil)
    feed = Atom::Feed.load_feed(src)
    results = []
    feed.entries.select do |entry|
      # feed.each_entry has a "since" parameter, but Flickr's feeds look
      # like they arrive in the wrong order for it
      since == nil or since < entry.published
    end .collect do |entry|
      results << {
        :id => entry.id,
        :caption => entry.title,
        :date => entry.published,
        :src => entry.links.enclosures.first.href,
        :link => entry.links.alternate.href
      }
    end
    results
  end
  
  class RSS
    
    def initialize(url)
      @url = url
    end
  
    def update(since)
      parse(open($url), since)
    end
    
  end
  
    
end
