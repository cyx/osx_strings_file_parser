require 'spec'
require File.dirname(__FILE__) + '/../lib/osx_strings_file_parser'

describe OsxStringsFileParser do
  describe "given PropertyName.strings" do
    before(:each) do
      @data = File.read( File.dirname(__FILE__) + '/fixtures/PropertyName.strings' )
      @parser = OsxStringsFileParser.new( @data )
    end
    
    it "should be able to split into 201 lines" do
      @parser.instance_variable_get("@lines").size.should == 201
    end
    
    it "should have only 189 key value pairs" do
      @parser.lines.size.should == 189
    end
    
    it "should attach the first comment to the first pair" do
      @parser.lines.first.comments.first.should == " First Line is a Multi Line Comment "
    end
    
    it "should attach the inline comment in the line as the second comment" do
      @parser.lines.first.comments[1].should == ' Yes we can have comments anywhere '
    end

    describe "parse" do
      it "should just be a shortcut to instantiatiating and to_hash" do
        parser = OsxStringsFileParser.new( @data )
        parser.to_hash.should == OsxStringsFileParser.parse( @data )
      end
    end
    
    describe "to_hash" do
      before(:each) do
        parser = OsxStringsFileParser.new( @data )
        @hash = parser.to_hash
        
        @test_values = {
          "Action" => "Action",
          "Activated Color" => "Activated Color",
          "Activated State" => "Activated State",
          "Activated Transp" => "Activated Transp",
          "Aspect Ratio" => "Aspect Ratio",
          "Alt+=" => "Alt+="
        }
      end

      it "should return a 189 sized hash" do
        @hash.size.should == 189
      end
      
      it "should have the test values present" do
        @test_values.each do |k, v|
          @hash[k].should == v
        end
      end
    end
  end
end

