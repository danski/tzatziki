require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::API do

  before :each do 
    @site = get_test_site
  end

  describe "initialization" do
    
    it "should index all the local data types"
    it "should index all the local specifications"
    it "should index all the local pages"
    
    it "should merge and override the data types found at this level with the list known to the parent"
    it "should merge and override the specifications found at this level with the list known to the parent"
    
    it "should use all non-hidden and non-underscored folders that do not end with a tilde as child APIs"
    it "should index all the APIs and start them recursing"
        
    # - root
    # - _templates
    # - _types
    # - _specifications
    # - _apis    
    # --- api_name
    # ------ _types
    # ------ _specifications
    # ------ index.markdown
    # ------ search.markdown
    # ------ another_api
    # --------- index.markdown
    # --------- _types
    
  end
  
end