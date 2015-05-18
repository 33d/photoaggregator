require "Atom.rb"
require 'minitest/autorun'
require 'time'
require 'stringio'

class Test_Atom <  Minitest::Test

  def setup
    @feed = ImageFeed::Atom.new open('tests/test_Atom_flickr.xml')
    def @feed.open(f)
      r = StringIO.new f, 'r'
      def r.read
        # Call the StringIO method in the only way I know how!
        str = self.class.instance_method(:read).bind(self).call()
        def str.content_type()
          'image/jpeg'
        end
        str
      end
      r
    end
  end
  
  def test_read_all()
    results = @feed.each.to_a
    assert_equal 20, results.length
  end
    
  def test_read_since()
    feed = ImageFeed::Atom.new open('tests/test_Atom_flickr.xml')
    results = @feed.each(Time.parse('2015-04-27T17:46:24Z')).to_a
    assert_equal 3, results.length
  end
  
  def test_read_item()
    item = @feed.each.to_a.first
    assert_equal 'tag:flickr.com,2005:/photo/17105504949', item[:id]
    assert_equal "It's green !!", item[:caption]
    assert_equal Time.parse('2015-04-27T17:50:01Z'), item[:date]
    assert_equal 'https://farm8.staticflickr.com/7661/17105504949_6b9e595105_b.jpg', item[:src]
    assert_equal 'https://www.flickr.com/photos/hameem15/17105504949/', item[:link]
  end
  
  def test_cache_with_since()
    puts '==============='
    results = @feed.each(Time.parse('2015-04-27T17:38:50Z'), {
      'tag:flickr.com,2005:/photo/17084261817' => 1,
      'tag:flickr.com,2005:/photo/17291685035' => 1
    })
    
    # Extract the IDs
    results = Hash[results.collect { |e| [e[:id], e] }]
    assert_equal 5, results.length
    
  end
  
end
