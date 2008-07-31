require File.dirname(__FILE__) + '/lib/osx_strings_file_parser'

if Object.const_defined?(:CharsetFu)
  OsxStringsFileParser.encoding_handler = CharsetFu
end
