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
  
  it "should set up a request factory when given a descriptive hash"

  it "should manufacture requests based on the data found in the parsable hash"
  it "should allow 20X-style request types as ranges"
  it "should recognise file uploads in the params"
  it "should automatically set the content-type to multipart form if a file is present"
  
  it "should manufacture response assertions based on the data found in the parsable hash"
  
  
  it "should make the response data available to the template payload"
  
end