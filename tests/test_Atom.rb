require "Atom.rb"
require 'test/unit'
require 'time'

class Test_Atom < Test::Unit::TestCase

  @@content = open('tests/test_Atom_flickr.xml')
  @@feed = ImageFeed::parse @@content

  def test_read_all()
    assert_equal 20, @@feed.length 
  end
    
  def test_read_since()
    r = ImageFeed::parse open('tests/test_Atom_flickr.xml'), Time.parse('2015-04-27T17:46:24Z')
    assert_equal 3, r.length
  end
  
  def test_read_item()
    require 'time'
    item = @@feed.first
    assert_equal 'tag:flickr.com,2005:/photo/17105504949', item[:id]
    assert_equal "It's green !!", item[:caption]
    assert_equal Time.parse('2015-04-27T17:50:01Z'), item[:date]
    assert_equal 'https://farm8.staticflickr.com/7661/17105504949_6b9e595105_b.jpg', item[:src]
    assert_equal 'https://www.flickr.com/photos/hameem15/17105504949/', item[:link]
  end
  
end
