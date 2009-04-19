require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::API do

  before :each do
    @site = get_test_site
    @site.read_specifications
    @site.read_types
    @api = get_test_api("the_google", @site)
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
      @api.parent.types.keys.each do |k|
        @api.types[k].should_not be_nil
      end
      (@api.types.keys - @api.parent.types.keys).should_not be_empty
    end
    it "should get the specifications hash from the parent" do
      @api.specifications.should_not be_empty
      @api.specifications["successful"].should be_kind_of(Tzatziki::Specification)
      @api.parent.specifications.keys.each do |k|
        @api.specifications[k].should_not be_nil
      end
      (@api.specifications.keys - @api.parent.specifications.keys).should_not be_empty
    end
    
    it "should call back to the parent when initialized" do
      @api.parent.children.should_not be_empty
    end
        
  end
  
  describe "processing" do
    
    it "should read the config file and merge with the parent" do
      @site.process
      @site.config.keys.should_not be_empty
      @site.config.keys.each do |k|
        @api.config[k].should == @site.config[k]
      end
      (@api.config.keys - @site.config.keys).should_not be_empty
    end
    
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
    it "should index all the layouts" do
      @site.read_layouts
      @site.local_layouts.keys.sort.should == ["default", "document", "specification", "type"]
      @api.read_layouts
      @api.local_layouts.keys.sort.should == ["custom"]
      @api.layouts.keys.sort.should == ["custom", "default", "document", "specification", "type"]
    end
    it "should index all the local documents" do
      @api.read_documents
      @api.documents.should_not be_empty
    end
    it "should index all the child APIs at level N+1" do
      @site.read_children
      @site.children.first.source.should include("github")
      @site.children.length.should == 2  
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
    
    it "should read all the documents and exclude the config file" do
      @api.read_documents
      @api.documents.length.should == 2
      @api.documents.values.first.should be_kind_of(Tzatziki::Document)
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
    
    it "should create an index page if one does not exist"
    
    it "should write the files recursively" do
      @site.document!
    end
  end
  
  it "should get it's title from the index file"
  it "should infer title from the folder name if no index file found"
  
  describe "configuration merging" do
    before(:each) do
      # this is the searchable hash
      # title: Generally searchable things on the The Google API
      # request:
      # 	query_string:
      #     q:
      #       type: search_query
      # 			description: An entity-escaped string that you wish to search for on The Google.
      
      
      # this is the date type hash
      # title: Date formatting
      # format: /\d{2}\/\d{2}\/\d{4}$/
      # example: 31/12/2009 
      
      @document_data = {
        :title=>"my document",
        :request=>{
          :query_string=>{
            :another_param=>{
              :description=>"I am expecting this to remain here but {{config.api_key}} should be replaced from the global spec and {{config.in_the_google}} should be replaced from the local spec."
            },
            :date=>{
              :type=>"date"
            }
          }
        },
        :specifications=>{
          :searchable=>true
        }
      }
      @output = @api.inject_specifications(@document_data)
      @output = @api.inject_types(@output)
      @output = @api.inject_configuration(@output)
      # The following tests are written in an absurdly prescriptive fashion because I want 
      # to be absolutely clear about the merge taking place.
    end
    it "should deep merge the specifications, giving priority to the local document scope" do
      @output[:request][:query_string][:q].should == {
        :type=>"search_query",
        :description=>"An entity-escaped string that you wish to search for on The Google.",
        :example=>"now you're thinking with portals",
        :layout=>"type"
      }
    end
    it "should deep merge the types, giving priority to the local document scope" do
      @output[:request][:query_string][:date].should == {
        :type=>"date",
        :title=>"Date formatting",
        :example=>"31/12/2009",
        :layout=>"type"
      }
    end  
    it "should render liquid markup into all the variables" do
      @output[:request][:query_string][:another_param].should == {
        :description=>"I am expecting this to remain here but FOOOOOBAAAAAAAR should be replaced from the global spec and YAAARRRRRRR should be replaced from the local spec."
      }      
    end
       
    it "should leave the specification keys in the original location" do
      @output[:specifications].should == {
        :searchable=>true
      }
    end    
    it "should leave the type keys in the original location" do
      @output[:request][:query_string][:date][:type].should == "date"
    end
    
    it "should run signing specifications at the very end of the chain"
  end
  
  describe "marshalling" do
    it "should provide a hashed version of the object" do
      h = @api.to_hash
      h[:config].should be_kind_of(Hash)
    end 
  end
  
end