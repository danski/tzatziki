require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Parsable do

  before(:all) do
    class ::TestParsable
      include Tzatziki::Documentable
      include Tzatziki::Parsable      
    end
  end
  before(:each) do
    @parsable = ::TestParsable.new("")
  end  
  
  it "should identify YAML blocks within the file, even multiple ones, and turn them into a big hash with symbolized keys" do
    @parsable.read(textile_fixture_path)
    data, template = @parsable.extract_yaml(@parsable.raw)
    data[:request].should be_kind_of(Hash)
    data[:response].should be_kind_of(Hash)
    data[:title].should be_kind_of(String)
    template.should_not match(/---/)
  end
  it "should allow defaults to be passed into the parse! method" do
    @parsable.read(textile_fixture_path)
    data, template = @parsable.parse!(@parsable.raw, {"layout"=>"specification"})
    data[:layout].should == "specification"
  end
  it "should replace YAML blocks with a liquid template marker"
  
end