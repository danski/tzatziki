require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Documentable do

  before(:all) do
    class ::TestDocumentable
      include Tzatziki::Documentable
      include Tzatziki::Parsable
    end
    class ::DocumentableOnly
      include Tzatziki::Documentable
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
    @documentable.data[:foo].should == "bar"
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
    @documentable = ::DocumentableOnly.new(textile_fixture_path, @api)
    lambda {@documentable.template_payload}.should raise_error(Tzatziki::InterfaceNotProvided)
  end
  
  it "should provide a default write location for the file"
  it "should write the file"
  
  describe "rendering" do 
    before(:each) do
      @documentable = ::TestDocumentable.new(textile_fixture_path, @api)
      @documentable.parse!  
    end
    
    it "should render the template with liquid helpers " do
      @documentable.raw = "{{title}}"
      render_output = @documentable.render
      render_output.should be_kind_of(String)
      render_output.should == "The Google Search API"
    end
  
    it "should render the template with each layout in turn" do
      @documentable.data[:layout] = "document"
      @documentable.payload.should == @documentable.data
      content = @documentable.render
      content.should include("DOCUMENT LAYOUT")
      content.should include("DEFAULT LAYOUT")
    end
  end
  
  describe "content transformation" do
    it "should transform textile files using RedCloth" do
      @documentable = ::TestDocumentable.new(textile_fixture_path, @api)
      @documentable.parse!
      @documentable.transform.should == RedCloth.new(@documentable.post_parse).to_html
    end
    it "should transform markdown files using Maruku" do
      @documentable = ::TestDocumentable.new(markdown_fixture_path, @api)
      @documentable.parse!
      @documentable.transform.should == Maruku.new(@documentable.post_parse).to_html
    end
    it "should not HTML files" do
      @documentable = ::TestDocumentable.new(html_fixture_path, @api)
      @documentable.parse!
      @documentable.transform.should == @documentable.post_parse
    end
  end
  
  
  it "should recognise multi-datablock input and use the YAML declares as placeholders for data tables"
  it "should recognise single datablock input and let the user specify where to place the tables"
  it "should place the request/response data tables at the end of the document if the user did not place them"
  
end