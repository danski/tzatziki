require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Parsable do

  before(:all) do
    class ::TestParsable
      include Tzatziki::Parsable
    end
  end
  before(:each) do
    @parsable = ::TestParsable.new
    @textile_path = File.join( File.dirname(__FILE__), "example", "source", "the_google", "index.textile" )
  end
  
  it "should read the file" do
    @parsable.read(@textile_path)
    @parsable.raw.should be_kind_of(String)
    @parsable.raw.should_not be_empty
  end
  it "should identify YAML blocks within the file, even multiple ones, and turn them into a big hash" do
    @parsable.read(@textile_path)
    data, template = @parsable.extract_yaml(@parsable.raw)
    data["request"].should be_kind_of(Hash)
    data["response"].should be_kind_of(Hash)
    data["title"].should be_kind_of(String)
    template.should_not match(/---/)
  end
  it "should replace YAML blocks with a liquid template marker"
  
end