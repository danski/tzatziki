require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Testable do
  
  before(:all) do
    class ::TestTestable
      include Tzatziki::Testable
    end
  end
  before(:each) do
    @testable = ::TestTestable.new
  end

  it "should provide defaults for the request object" do
    Tzatziki::Testable.default_request_factory_options.should be_kind_of(Hash)
  end
  it "should provide defaults for the response assertions" do
    Tzatziki::Testable.default_response_assertion_options.should be_kind_of(Hash)
  end
  it "should merge the request options with the document-specific request options with symbol keys" do
    @testable.request_options.should be_kind_of(Hash)
    @testable.request_factory_options = {:injected=>true, :headers=>{
      :"content-accept"=>"overridden"
    }}
    @testable.request_options.should be_kind_of(Hash)
    @testable.request_options[:injected].should == true
    @testable.request_options[:headers][:"content-accept"].should == "overridden"
  end
  it "should merge the response options with the document-specific response options with symbol keys" do
    @testable.response_options.should be_kind_of(Hash)
    @testable.response_assertion_options = {"injected"=>true, :status=>"feesh", :nested=>{"deep_symbolized"=>true}}
    @testable.response_options.should be_kind_of(Hash)
    @testable.response_options[:injected].should == true
    @testable.response_options[:status].should == "feesh"
    @testable.response_options[:nested][:deep_symbolized].should == true
  end
  
  describe "request factory" do
    it "should set up a request factory when given a descriptive hash"
    it "should manufacture requests based on the data found in the parsable hash"
    
    it "should run values through the liquid helpers"
        
    it "should support :method in the options hash"
    it "should support :protocol in the options hash"
    it "should support :domain in the options hash"
    it "should support :uri in the options hash"
    it "should support :query_string in the options hash"
    it "should support :form_body in the options hash"
    it "should support :headers in the options hash"
    it "should support :multipart_form in the options hash"
    it "should support :basic_auth in the options hash"
    
    describe "value generation" do
      it "should support :example in the options hash for a value"
      it "should support :format in the options hash for a value"
      it "should support :required in the options hash for a value"
      it "should support :values with a list of options in the options hash for a value"
      it "should support :default in the options hash for a value"
      it "should ignore :default if :required is TRUE and :values is not specified"
    end
  end
  
  describe "response assertions" do
    it "should allow 20X-style request types as ranges"
    it "should recognise words like 'Success' as HTTP response class types e.g. HTTPSuccess"
    
    it "should recognise file uploads in the params"
    it "should automatically set the content-type to multipart form if a file is present"
  
    it "should manufacture response assertions based on the data found in the parsable hash"
    
    it "should return tuple of test result (:success,:pending,:fail) and message"
    
    it "should match against :status in the response hash"
    it "should match against :body in the response hash"
    it "should match against :body by CSS in the response hash when the returned content type is an XML variant"
    it "should match against :body by XPath in the response hash when the returned content type is an XML variant"
    it "should match against :body by XPath in the response hash when the returned content type is an JSON variant"
    it "should match against :body by XPath in the response hash when the returned content type is an YAML variant"
  end  
  
  describe "response post-processing" do
    it "should make the real response data available to the template payload"
  end
  
end