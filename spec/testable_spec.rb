require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Testable do
  
  before(:all) do
    class ::TestTestable
      include Tzatziki::Testable
    end
  end
  before(:each) do
    # Get the google search test document. It's true that the Document
    # class also includes Parsable and Documentable, but we want to run
    # something at least approximating a real-world example here.
    @api = get_test_api
    @testable = @api.documents["search"]
    @testable.should be_kind_of(Tzatziki::Testable)
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
  
  describe "response post-processing" do
    it "should make the real response data available to the template payload" do
      @testable.test!
      @testable.response.to_payload_hash.should_not be_empty
      @testable.template_payload[:response][:headers].should_not be_nil
      @testable.template_payload[:response][:status].should_not be_nil
      @testable.template_payload[:response][:code].should_not be_nil
      @testable.template_payload[:response][:body].should_not be_nil
    end
  end
  
end