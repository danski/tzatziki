require 'net/http'
require File.dirname(__FILE__) + '/spec_helper'

describe Net::HTTPRequest do
  
  before(:each) do
    # We'll test this using the factory hash from a real-world testable object
    @api = get_test_api
    @testable = @api.documents["search"]
  end
  
  it "should be created from a Tzatziki options hash" do
    (req_data = @testable.data[:request]).should_not be_empty
    @request = Net::HTTPRequest.from_hash(req_data)
  end
  it "should accept a block as an argument for returning the response object" do
    @response = Net::HTTPRequest.from_hash(@testable.data[:request]) { |http, req| http.request(req) }.should be_kind_of(Net::HTTPResponse)
  end
  
  describe Net::HTTPRequest::Factory do
    before(:each) do
      @params = {
        :pattern_generation=>{
          :description=>"bar",
          :pattern=>"\w{10}",
        },
        :pattern_generation_with_example=>{
          :description=>"bar",
          :format=>"\w{10}",
          :example=>"FOOOOO"
        },
        :multiple_choice=>{
          :description=>"baz",
          :required=>false,
          :values=>{
            "foo"=>"bar",
            "bar"=>"baz"
          },
          :default=>"foo"
        },
        :multiple_choice_with_example=>{
          :description=>"baz",
          :required=>false,
          :values=>{
            "foo"=>"bar",
            "bar"=>"baz"
          },
          :default=>"foo",
          :example=>"bar"
        }
      }
    end
    
    it "should generate query strings from parameter hashes" do
      @output = Net::HTTPRequest::Factory.parameter_hash_to_query_string(@params)
      @output.should =~ /pattern_generation=(\w+)/
      @output.should =~ /pattern_generation_with_example=FOOOOO/
      @output.should =~ /multiple_choice=foo/
      @output.should =~ /multiple_choice_with_example=bar/
    end
  end
  
  describe "Request Factory options" do
    before(:all) do
      @api = get_test_api
      @testable = @api.documents["search"]
      @uri = Net::HTTPRequest::Factory.specification_hash_to_uri(@testable.data[:request])
      @request = Net::HTTPRequest.from_hash(@testable.data[:request])
      @response = Net::HTTPRequest.from_hash(@testable.data[:request]) { |http, req| http.request(req) }
    end
    
    it "should recognise file uploads in the params"
    it "should automatically set the content-type to multipart form if a file is present"
    
    it "should support :method in the options hash" do
      @request.should be_kind_of(Net::HTTP::Get)
    end
    it "should support :protocol in the options hash" do
      @uri.scheme.should == @testable.data[:request][:protocol]
    end
    it "should support :host in the options hash" do
      @uri.host.should == @testable.data[:request][:host]
    end
    it "should support :uri in the options hash" do
      @uri.path.should == @testable.data[:request][:uri]
    end
    it "should support :query_string in the options hash" do
      @uri.query.should == Net::HTTPRequest::Factory.parameter_hash_to_query_string(@testable.data[:request][:query_string])
    end
    it "should support :form_data in the options hash"
    it "should support :headers in the options hash" do
      @request["custom"].should == "add a custom header"
    end
    it "should support :basic_auth in the options hash"
  end
  
end