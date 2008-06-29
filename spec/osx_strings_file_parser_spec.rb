require 'spec'
require File.dirname(__FILE__) + '/../lib/osx_strings_file_parser'

describe OsxStringsFileParser do
  describe "given PropertyName.strings" do
    before(:each) do
      @data = File.read( File.dirname(__FILE__) + '/fixtures/PropertyName.strings' )
    end

    describe "to_hash" do
      before(:each) do
        parser = OsxStringsFileParser.new( @data )
        @hash = parser.to_hash
      end
      
      before(:each) do
        @test_values = {
          "Action" => "Action",
          "Activated Color" => "Activated Color",
          "Activated State" => "Activated State",
          "Activated Transp" => "Activated Transp",
          "Aspect Ratio" => "Aspect Ratio"
        }
        
      end
      
      it "should return a 188 sized hash" do
        @hash.size.should == 188
      end
      
      it "should have the test values present" do
        @test_values.each do |k, v|
          @hash[k].should == v
        end
      end
    end
  end
end

