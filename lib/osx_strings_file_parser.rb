require 'active_support'
require 'iconv'

class OsxStringsFileParser
  def initialize( data )
    @data = get_utf8_from( data )
  end

  def self.parse( data )
    new( data ).to_hash
  end

  def to_hash
    hash = {}
    @data.chars.split(';').each do |line|
      next if line.blank?
      
      key, value = line.chars.split('=')
      key = remove_quotes_from(key)
      value = remove_quotes_from(value)

      hash[key.to_s] = value.to_s
    end
    return hash
  end

  protected
    def remove_quotes_from( string )
      string.chars.strip.chomp('"').reverse.chomp('"').reverse                 
    end
    
    def get_utf8_from( data )
      Iconv.iconv('UTF-8', 'UTF-16', data).to_s
    end
end
