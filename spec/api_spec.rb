require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::API do

  before :each do
    @site = get_test_site
    @site.read_specifications
    @site.read_types
    @api = get_test_api(@site)
  end
  
  it "should == another instance with the same source path" do
    @site.should == get_test_site
  end  
  it "should be able to traverse the parent structure to find the root site instance" do
    @api.site.should == @site
  end
  it "should be able to determine own position in file system relative to site root" do
    @api.path_offset.should == "the_google"
    @api.read_children
    @api.children.first.path_offset.should == "the_google/mail"
  end

  describe "initialization" do
    
    it "should get the data types hash from the parent" do
      @api.types.should_not be_empty
      @api.types["date"].should be_kind_of(Tzatziki::Type)
      @api.types.should == @api.parent.types
    end
    it "should get the specifications hash from the parent" do
      @api.specifications.should_not be_empty
      @api.specifications["successful"].should be_kind_of(Tzatziki::Specification)
      @api.specifications.should == @api.parent.specifications
    end
    
    it "should call back to the parent when initialized" do
      @api.parent.children.should == [@api]
    end
        
  end
  
  describe "processing" do
    
    it "should index all the local data types" do
      @site.read_types
      @site.local_types.keys.should == ["date"]
      @api.read_types
      @api.local_types.keys.should == ["search_query"]
    end
    it "should index all the local specifications" do
      @site.read_specifications
      @site.local_specifications.keys.should == ["successful"]
      @api.read_specifications
      @api.local_specifications.keys.should == ["searchable"]
    end
    it "should index all the local documents" do
      @api.read_documents
      @api.documents.should_not be_empty
    end
    it "should index all the child APIs at level N+1" do
      @site.read_children
      @site.children.first.source.should include("the_google")
      @site.children.length.should == 1      
      @api.read_children
      @api.children.first.source.should include("mail")
    end
    
    it "should ignore folders ending with a tilde" do
      # Assert that a folder with .examples does exist
      entries = Dir.entries(@api.source)
      entries.select { |e| e.match(/~/) }.should_not be_empty
      # Assert that no API with that path was created
      @api.children.each do |c|
        c.source.should_not match(/~/)
      end
    end
    
    it "should not use folders ending with .examples as child APIs" do
      # Assert that a folder with .examples does exist
      entries = Dir.entries(@api.source)
      entries.select { |e| e.match(/\.examples$/) }.should_not be_empty
      # Assert that no API with that path was created
      @api.children.each do |c|
        c.source.should_not match(/\.examples/)
      end
    end
    
    it "should index all the APIs and start them recursing when #process is called" do
      @site = get_test_site
      @site.process
      @site.children.first.children.should_not be_empty
    end
    
    it "should read all the documents" do
      @api.read_documents
      @api.documents.length.should == 2
      @api.documents.first.should be_kind_of(Tzatziki::Document)
    end
    
    it "should merge the data types found at this level with the list known to the parent without altering the types hash on the parent" do
      @site.read_types; @api.read_types
      @api.types.keys.should == ["date","search_query"]
      @site.types.keys.should == ["date"]
    end
    it "should merge the specifications found at this level with the list known to the parent without altering the specs hash on the parent" do
      @site.read_specifications; @api.read_specifications
      @api.specifications.keys.should == ["searchable","successful"]
      @site.specifications.keys.should == ["successful"]
    end    
  end
  
end