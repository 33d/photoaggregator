require 'Imgur.rb'

require "test/unit"
require "mocha/test_unit"

class Test_Imgur < Test::Unit::TestCase
  
  def test_parse_album()
    albums = ImageFeed::Imgur.parse_albums Zlib::GzipReader.new(File.open('tests/test_Imgur_album.html.gz'))
    assert_equal 27, albums.length
    a = albums.first
    assert_equal 'http://imgur.com/a/clj0A', a[:url]
    assert_equal 'What did I do!?', a[:name]
    assert_equal Time.parse('2015-04-30T19:54:00Z'), a[:date]
  end
  
  def test_get_album_images()
    urls = {
      '/I6P6tyT.jpg' => Time.new(2015, 03, 10),
      '/bq4KxHy.jpg' => Time.new(2015, 03, 10),
      '/Y3GQ06L.jpg' => Time.new(2015, 03, 11),
      '/Jq33Tbj.jpg' => Time.new(2015, 03, 12),
      '/afQXeIk.jpg' => Time.new(2015, 03, 12),
      '/R4iQC6y.jpg' => Time.new(2015, 03, 12),
      '/GsxkPfi.jpg' => Time.new(2015, 03, 12),
      '/wNGsLKL.jpg' => nil,
      '/sgmyDXj.jpg' => nil
    }
    last_request = Time.new(2015, 03, 11, 12)
    http = mock()
    urls.each do |url, mtime|
      modified = urls[url]
      result = Object.new
      result.define_singleton_method :code do
        modified && (last_request < modified && '200' || '304') || '404'
      end
      http.expects(:head).with(url, has_entry('If-Modified-Since', last_request.rfc2822)).returns(result)
    end

    ImageFeed::Imgur.get_album_images urls.keys, last_request, http
  end

end
