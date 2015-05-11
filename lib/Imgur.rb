require 'nokogiri'

# Loosely based on http://github.com/ericdke/nokaya

module ImageFeed
  
  class Imgur

    def self.parse_albums(source)
      html = Nokogiri::parse(source)
      html.css('.album').collect do |album|
        {
          :url => 'http:' + album.css('.cover a @href').first.content,
          :name => album.css('.info').first.content.strip,
          :date => Time.strptime(album.css('.metadata span @title').first.content, '%A, %B %e, %Y at %k:%M %Z')
        }
      end
    end

    def self.get_album_images(urls, since, http=nil)
      since = since.rfc2822
      http = http || Net::HTTP::new(URI('http://www.imgur.com/'))
      urls.inject([]) do |results, url|
        response = http.head URI(url).path, { 'If-Modified-Since' => since }
        response.code == '200' && (results << url)
        results
      end
    end

  end

end
