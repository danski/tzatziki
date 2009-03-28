require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::API do

  before :each do
    @site = get_test_site
    @site.read_specifications
    @site.read_types
    @api = get_test_api(@site)
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
    
    it "should index all the local data types"
    it "should index all the local specifications" do
      @site.read_specifications
    end
    it "should index all the local documents"
    it "should index all the child APIs at level N+1"
    
    it "should use all non-hidden and non-underscored folders that do not end with a tilde as child APIs"
    it "should index all the APIs and start them recursing"
    
    it "should merge and override the data types found at this level with the list known to the parent"
    it "should merge and override the specifications found at this level with the list known to the parent"
    
    it "should merge a duplicate of the data types hash, without affecting the data types hash on the parent"
    it "should merge a duplicate of the specifications hash, without affecting the specifications hash on the parent"
    
  end
  
end