require 'active_support'
require 'iconv'

class OsxStringsFileParser
  class FauxEncodingHandler
    def self.convert( data )
      data
    end
  end
  
  class KeyValuePair < Struct.new(:key, :value, :comments)
    def attributes
      { :text => value, :data => { 'key' => key, 'comments' => comments }}
    end
  end
  
  REGEX_COMMENT_MULTI  = /\/\*(.*?)\*\//  
  REGEX_COMMENT_SINGLE = /\/\/[^\n]*/
  REGEX_LINES = /\r\n|\r|\n|\u0085|\u2028|\u2029/  
  REGEX_QUOTED = /\"((\\\"|[^\"])+)\"/
  REGEX_KEY_VALUE = /#{REGEX_QUOTED}\s*=\s*#{REGEX_QUOTED}/
  
  class_inheritable_accessor :encoding_handler
  self.encoding_handler = FauxEncodingHandler
  
  def initialize( data )
    @data = encoding_handler.convert(data)
    @lines ||= @data.chars.split(REGEX_LINES)
    @idx = -1
    @line = nil
    @pairs = []
    @comments = []
    
    while next_line
      if comment = @line.match(REGEX_COMMENT_MULTI)
        @comments << comment[1]
        unless (@remainder = @line.gsub(REGEX_COMMENT_MULTI, '').strip) == ''
          if pair = @remainder.match(REGEX_KEY_VALUE)
            @pairs << KeyValuePair.new(pair[1], pair[3], @comments.dup)
            @comments = []
          end
        end
      elsif pair = @line.match(REGEX_KEY_VALUE)
        @pairs << KeyValuePair.new(pair[1], pair[3], @comments.dup)
        @comments = []
      end
    end
  end
  
  def next_line
    @line = @lines[@idx += 1]
  end
  
  def lines
    @pairs
  end
  
  def to_hash
    return @hash if @hash
    @hash = returning( {} ) do |hash|
      lines.each { |key_value| hash[key_value.key] = key_value.value }
    end
  end
  
  def self.parse( data )
    new( data ).to_hash
  end
end
