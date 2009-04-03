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
    request = Net::HTTPRequest.from_hash(req_data)
  end
  it "should accept a block as an argument for returning the response object"
  
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