require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Documentable do

  before(:all) do
    class ::TestDocumentable
      include Tzatziki::Documentable
      include Tzatziki::Parsable
    end
    class ::TestDocumentableWithInterface < ::TestDocumentable
      def payload
        {:foo=>"bar"}
      end
    end
  end
  before(:each) do
    @api = get_test_api
    @documentable = ::TestDocumentable.new("", get_test_api)
  end

  it "should be initable with a path and an api instance" do
    @documentable = ::TestDocumentable.new(textile_fixture_path, @api)
    f = File.open(textile_fixture_path)
    @documentable.raw.should == f.read
  end
  it "should be initable with a content string and an api instance" do
    doc = <<-DOC.strip
---
foo: bar
===

i am the walrus
    DOC
    @documentable = ::TestDocumentable.new(doc, @api)
    @documentable.raw.should == doc
    @documentable.parse!
    @documentable.data["foo"].should == "bar"
  end
  
  it "should read the file" do
    @documentable.read(textile_fixture_path)
    @documentable.raw.should be_kind_of(String)
    @documentable.raw.should_not be_empty
  end
  
  it "should provide global options to the liquid template" do
    @documentable = ::TestDocumentableWithInterface.new(textile_fixture_path, @api)
    @documentable.template_payload.should be_kind_of(Hash)
  end
  it "should raise an error if the implementing class does not provide its own options for the liquid template" do
    @documentable = ::TestDocumentable.new(textile_fixture_path, @api)
    lambda {@documentable.template_payload}.should raise_error(Tzatziki::InterfaceNotProvided)
  end
  
  it "should provide a default write location for the file"
  it "should write the file"
  
  it "should render the template with a layout"
  it "should render the template with liquid helpers "
  
end