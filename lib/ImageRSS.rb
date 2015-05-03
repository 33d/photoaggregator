require 'open-uri'
require 'simple-rss'

def parse(str, since=nil)
  rss = SimpleRSS.parse str
  rss.items.select { |item|
    since == nil || since < item.published
  }.collect { |item|
    {
      :id => item.id,
      :caption => item.title,
      :date => item.published,
      :src => "",
      :link => item.link
    }
  }
end

class ImageRSS
  
  def initialize(url)
    @url = url
  end

  def update(since)
    parse(open($url).read, since)
  end
  
end
