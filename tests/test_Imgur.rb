require 'Imgur.rb'

class Test_Imgur < Test::Unit::TestCase
  
  def test_parse_album()
    albums = ImageFeed::Imgur.parse_albums Zlib::GzipReader.new(File.open('tests/test_Imgur_album.html.gz'))
    assert_equal 27, albums.length
    a = albums.first
    assert_equal 'http://imgur.com/a/clj0A', a[:url]
    assert_equal 'What did I do!?', a[:name]
    assert_equal Time.parse('2015-04-30T19:54:00Z'), a[:date]
  end
  
end
