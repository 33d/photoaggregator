require 'open-uri'
require 'atom'

module ImageFeed
  
  class Atom
    
    def initialize(src)
      @src = src.is_a?(IO) && src || open(src)
    end
  
    def each(since=nil, cache={})
      return enum_for(:each, since, cache) unless block_given?
      
      feed = ::Atom::Feed.load_feed(@src)
      feed.entries.select do |entry|
        # feed.each_entry has a "since" parameter, but Flickr's feeds look
        # like they arrive in the wrong order for it
        since == nil || (!cache.has_key?(entry.id) && since < entry.published)
      end .collect do |entry|
        content = open(entry.links.enclosures.first.href).read
        yield({
          :id => entry.id,
          :caption => entry.title,
          :date => entry.published,
          :src => entry.links.enclosures.first.href,
          :link => entry.links.alternate.href,
          :image => content,
          :type => content.content_type
        })
      end

    end

  end
    
end
